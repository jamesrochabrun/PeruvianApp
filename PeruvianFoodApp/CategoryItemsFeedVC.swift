//
//  FilterVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/6/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CategoryItemsFeedVC: FeedVC {
    
    //MARK: Properties
    var categoryViewModel: CategoryViewModel? {
        didSet {
            if let cvm = categoryViewModel {
                self.categoryItemsFeedDataSource = CategoryItemsFeedDataSource(categoryViewModel: cvm)
                self.categoryItemsFeedDataSource?.categoryItemsFeedVC = self
                self.title = cvm.categoryListTitle
            }
        }
    }
    var categoryItemsFeedDataSource: CategoryItemsFeedDataSource?
    
    //MARK: App Lyfecycle
    override func viewDidLoad() {
        
        setUpNavBar()
        setUpTableView()
    }
    
    //MARK: FeedVC super class methods
    override func setUpTableView() {
        
        tableView.backgroundColor = .white
        tableView.register(SwitchCell.self)
        if let cifds = categoryItemsFeedDataSource {
            tableView.registerDatasource(cifds, completion: { (complete) in })
        }
    }

    override func setUpNavBar() {
        super.setUpNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SEARCH", style: .plain, target: self, action: #selector(searchAndOpenResults))
    }
    
    //MARK: navigation triggers
    func searchAndOpenResults() {
        
        feedSearchBar.endEditing(true)
        let businessFeedVC = BusinessesFeedVC()
        if let categoryItemsFeedDataSource = categoryItemsFeedDataSource {
            businessFeedVC.selection = categoryItemsFeedDataSource.selection
        }
        self.navigationController?.pushViewController(businessFeedVC, animated: true)
    }
}

//MARK: tableview methods
extension CategoryItemsFeedVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}





























