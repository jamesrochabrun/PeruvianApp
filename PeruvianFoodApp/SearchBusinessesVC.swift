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
        tv.register(ReusableHeaderCell.self)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let reusableHeaderCell = tableView.dequeueReusableCell() as ReusableHeaderCell
        if let title = dataSource.getAutoCompleteResponse()?.titles[section] {
            reusableHeaderCell.setUpWith(text: title)
        }
        return reusableHeaderCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.UI.reusableHeaderCellHeight
    }
}


import TRON
import SwiftyJSON

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
            case .Error(let error):
                print("\(error)")
            }
        }
    }
}



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
        
//        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCell
//        if let response = autoCompleteResponse {
//            let data: [JSONDecodable] = response.content[indexPath.section]
//            cell.setUpWith(data: data, atIndex: indexPath.row)
//        }

        
        guard let response = autoCompleteResponse else {
            print("HELP!!")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCell
        if indexPath.section == 0 {
            cell.autoCompleteTextLabel.text = response.businesses[indexPath.row].name
            cell.setBusinessImageViewFrom(id: response.businesses[indexPath.row].id)
        } else if indexPath.section == 1 {
            cell.autoCompleteTextLabel.text = response.terms[indexPath.row].text
            cell.businessImageView.image = nil
        } else {
            cell.autoCompleteTextLabel.text = response.categories[indexPath.row].title
            cell.businessImageView.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteResponse != nil ? autoCompleteResponse!.content[section].count : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return autoCompleteResponse != nil ? autoCompleteResponse!.content.count : 0
    }
    
    //MARK: Helper method
    func getAutoCompleteResponse() -> AutoCompleteResponse? {
        return autoCompleteResponse
    }
}

















