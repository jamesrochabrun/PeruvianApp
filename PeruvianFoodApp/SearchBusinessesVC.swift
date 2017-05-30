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
    let dataSource = SearchBusinessesDataSource()
   
    lazy var businessesTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.register(BusinessCell.self)
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
        
        
        print("\(searchController.searchBar.text!)")
        //        dataSource.update(with: [Stub.artist])
//        client.searchForArtists(withTerm: searchController.searchBar.text!) { [weak self] (artists, error) in
//            self?.dataSource.update(with: artists)
//            self?.tableView.reloadData()
//        }
    }
}

final class SearchBusinessesDataSource: NSObject, UITableViewDataSource {
    
    //MARK: Tableview Datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BusinessCell
        cell.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}







