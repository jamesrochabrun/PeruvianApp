//
//  TermBusinessesVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/29/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class SearchBusinessesVC: UIViewController {
    
    //MARK: UI Properties
    let searchController = UISearchController(searchResultsController: nil)
    let dataSource = AutoCompleteResultsDataSource()
   
    lazy var businessesTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.dataSource = self.dataSource
        tv.register(AutoCompleteBusinessCell.self)
        tv.tableHeaderView = self.searchController.searchBar
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 100
        return tv
    }()
    
    //MARK: app Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            businessesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            businessesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            businessesTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            businessesTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
    }
    
    func setUpViews() {
        
        view.backgroundColor = .white
        view.addSubview(businessesTableView)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        //this hides the searchbar in the next vc
        definesPresentationContext = true
    }
}

//MARK: tableview delegate methods
extension SearchBusinessesVC: UITableViewDelegate {
    
}

//MARK: Search updates protocol "delegate" gets triggered every time
extension SearchBusinessesVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let textToSearch = searchController.searchBar.text else { return }
        
        let selection = Selection()
        selection.term = textToSearch
        
        YelpService.sharedInstance.getAutoCompleteResponseFrom(selection: selection) { (result) in
            switch result {
            case .Success(let response):

                self.dataSource.update(with: response)
                self.businessesTableView.reloadData()
                dump(response)
            case .Error(let error):
                print("\(error)")
            }
        }
    }
}


import TRON
import SwiftyJSON

final class AutoCompleteResultsDataSource: NSObject, UITableViewDataSource {
    
    //MARK: Properties
    fileprivate var selection = Selection()
    fileprivate var autoCompleteResponse: AutoCompleteResponse?

    //MARK: initializers
    override init() {
        super.init()
    }
    
    //MARK: response updater 
    func update(with response: AutoCompleteResponse) {
        autoCompleteResponse = response
    }
    
    //MARK: Tableview Datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCell
        if let response = autoCompleteResponse {
            let data: [JSONDecodable] = response.content[indexPath.section]
            cell.setUpWith(data: data, atIndex: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteResponse != nil ? autoCompleteResponse!.content[section].count : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return autoCompleteResponse != nil ? autoCompleteResponse!.content.count : 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return autoCompleteResponse?.titles[section]
    }
}

class AutoCompleteBusinessCell: BaseCell {
    
    //MARK: UI elements
    let autoCompleteTextLabel = LabelBuilder.headerLabel(textColor: .darkTextColor, textAlignment: .left, sizeToFit: true).build()
    var businessImageView = ImageViewBuilder.imageView(radius: 10.0, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Colors.grayTextColor.color
        return v
    }()
    
    override func setUpViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(autoCompleteTextLabel)
        contentView.addSubview(businessImageView)
        addSubview(dividerLine)

        
        NSLayoutConstraint.activate([
            
            businessImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            businessImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            businessImageView.widthAnchor.constraint(equalToConstant: 40),
            businessImageView.heightAnchor.constraint(equalToConstant: 40),
            
            autoCompleteTextLabel.leftAnchor.constraint(equalTo: businessImageView.rightAnchor, constant: 15),
            autoCompleteTextLabel.centerYAnchor.constraint(equalTo: businessImageView.centerYAnchor),
            
            autoCompleteTextLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -7),
            autoCompleteTextLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            
            dividerLine.heightAnchor.constraint(equalToConstant: 0.3),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.swicthCellPadding),
            dividerLine.rightAnchor.constraint(equalTo: rightAnchor)
            ])
    }
    
    func setUpWith(data: [JSONDecodable], atIndex index: Int) {

        if let autoCompleteTerms = data as? [AutoCompleteTerm] {
            autoCompleteTextLabel.text = autoCompleteTerms[index].text
            businessImageView.image = nil
        }
        
        if let autoCompleteBusinesses = data as? [AutoCompleteBusiness] {
            autoCompleteTextLabel.text = autoCompleteBusinesses[index].name
            setBusinessImageViewFrom(id: autoCompleteBusinesses[index].id)
        }
        
        if let autoCompleteCategories = data as? [AutoCompleteCategory] {
            autoCompleteTextLabel.text = autoCompleteCategories[index].title
            businessImageView.image = nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        businessImageView.image = nil

    }
    
    //MARK: helper method
    private func setBusinessImageViewFrom(id: String) {
        
        YelpService.sharedInstance.getBusinessWithID(id) { [weak self] (result) in
            switch result {
            case .Success(let business):
                
                guard let url = URL(string: business.imageURL) else {
                    print("INVALID URL ON CREATION BASECELL")
                    return
                }
                self?.businessImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: true) { [weak self] (response) in
                    guard let image = response.result.value else {
                        print("No image data in response AutocompletCell")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.businessImageView.image = image
                    }
                }
            case .Error(let error):
                print("ERROR ON AUTOCOMPLETCELL FETCHING BUSINESS: \(error)")
            }
        }
    }
}
















