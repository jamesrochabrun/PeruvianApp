//
//  TermBusinessesVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/29/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class AutoCompleteVC: UIViewController {
    
    //MARK: UI Properties
    let searchController = UISearchController(searchResultsController: nil)
    let dataSource = AutoCompleteResponseDataSource()
   
    lazy var businessesTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.dataSource = self.dataSource
        tv.register(AutoCompleteBusinessCell.self)
        tv.register(ReusableHeaderCell.self)
        tv.register(AutoCompleteBusinessCellText.self)
        tv.register(UITableViewCell.self)
        
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
extension AutoCompleteVC: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let something = dataSource.getAutoCompleteResponse()?.content[indexPath.section][indexPath.row]
        print("Something: \(something)")
    }
}


//MARK: Search updates protocol "delegate" gets triggered every time
extension AutoCompleteVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let textToSearch = searchController.searchBar.text else { return }
        
        if textToSearch.characters.count == 0 {
            updateDataIfTextIsBlank()
            
        } else {
            updateSelectionWith(term: textToSearch)
        }
    }
    
    //MARK: helper methods
    func updateDataIfTextIsBlank() {

        self.dataSource.update(with: nil)
        self.businessesTableView.reloadData()
    }
    
    func updateSelectionWith(term: String) {
        
        let selection = Selection()
        selection.term = term
        
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
















