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
        
        setUpNavBar()
        setUpViews()
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataInVC), name: NSNotification.Name(rawValue: "name"), object: nil)
        
    }
    
    override func setUpTableView() {
        tableView.register(CategoryCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = categoryDataSource
        categoryDataSource.categoryFeedVC = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "name"), object: nil);
    }
    
    func reloadDataInVC() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.customIndicator.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let categoryViewModel = categoryDataSource.getCategoriesArray()[indexPath.row]
        let categoryItemsFeedVC = CategoryItemsFeedVC()
        categoryItemsFeedVC.categoryViewModel = categoryViewModel
        self.navigationController?.pushViewController(categoryItemsFeedVC, animated: true)
    }
}










