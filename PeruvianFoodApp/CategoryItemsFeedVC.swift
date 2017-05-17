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
                self.title = cvm.mainCategory.rawValue
            }
        }
    }
    var categoryItemsFeedDataSource: CategoryItemsFeedDataSource?
    
    //MARK: App Lyfecycle
    override func viewDidLoad() {
        
        setUpNavBar()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: FeedVC super class methods
    //overriding method to avoid customindicator
    override func setUpTableView() {
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])

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
            businessFeedVC.selection = categoryItemsFeedDataSource.getSelection()
        }
        self.navigationController?.pushViewController(businessFeedVC, animated: true)
    }
}

//MARK: tableview methods
extension CategoryItemsFeedVC {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}






























