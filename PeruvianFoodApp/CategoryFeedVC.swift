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
    
    //MARK: Properties
    var categoryDataSource = CategoryDataSource()
    
    //MARK: APP lyfecycle
    override func viewDidLoad() {
        
        setUpNavBar()
        setUpViews()
        setUpTableView()
        categoryDataSource.delegate = self
        LabelBuilder.printFonts()

    }
    
    //MARK: FeedVC super class methods
    override func setUpTableView() {
        tableView.register(CategoryCell.self)
        tableView.dataSource = categoryDataSource
        categoryDataSource.categoryFeedVC = self
    }
    
    //MARK: triggered by delegation
    @objc private func reloadDataInVC() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.customIndicator.stopAnimating()
        }
    }
}

//MARK: update data by delegation
extension CategoryFeedVC: CategoryDataSourceDelegate {
    
    func updateDataInVC() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.customIndicator.stopAnimating()
        }
    }
}

//MARK: tableview delegate
extension CategoryFeedVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        feedSearchBar.endEditing(true)
        let categoryViewModel = categoryDataSource.searchActive ? categoryDataSource.searchResults[indexPath.row] : categoryDataSource.getCategoriesArray()[indexPath.row]
        let categoryItemsFeedVC = CategoryItemsFeedVC()
        categoryItemsFeedVC.categoryViewModel = categoryViewModel
        self.navigationController?.pushViewController(categoryItemsFeedVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}










