//
//  CategoryFeedVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CategoryFeedVC: FeedVC {
    
    var categoryDataSource = CategoryDataSource()
    
    override func viewDidLoad() {
        
       // setUpNavBar()
//        setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataInVC), name: NSNotification.Name(rawValue: "name"), object: nil)
    }
    
    override func setUpNavBar() {
        super.setUpNavBar()
    }
    
    override func setUpViews() {
        super.setUpViews()
    }
    
    override func setUpTableView() {
        tableView.register(CategoryCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = categoryDataSource
        self.categoryDataSource.categoryFeedVC = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "name"), object: nil);
    }
    
    func reloadDataInVC() {
        tableView.reloadData()
        customIndicator.stopAnimating()
    }
    
//    override func setUpNavBar() {
//        navigationItem.titleView = feedSearchBar
//    }
}





