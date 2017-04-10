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
    
    var categoryViewModel: CategoryViewModel? {
        didSet {
            if let cvm = categoryViewModel {
                self.categoryItemsFeedDataSource = CategoryItemsFeedDataSource(categoryViewModel: cvm)
                self.categoryItemsFeedDataSource?.categoryItemsFeedVC = self
            }
        }
    }
    
    var categoryItemsFeedDataSource: CategoryItemsFeedDataSource? {
        didSet {
            if let cifds = categoryItemsFeedDataSource {
                tableView.registerDatasource(cifds, completion: { (complete) in })
            }
        }
    }

    override func viewDidLoad() {
        
        setUpNavBar()
        setUpTableView()
    }
    
    override func setUpTableView() {
        
        tableView.backgroundColor = .white
        tableView.register(SwitchCell.self)
    }

    override func setUpNavBar() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SEARCH", style: .plain, target: self, action: #selector(searchAndDismiss))
    }
    
    func searchAndDismiss() {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}






























