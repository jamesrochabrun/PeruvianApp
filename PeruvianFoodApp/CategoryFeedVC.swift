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
    var locationManager = LocationManager()
    
    //MARK: APP lyfecycle
    override func viewDidLoad() {
        
        setUpNavBar()
        setUpTableView()
        setUpViews()
        categoryDataSource.delegate = self
        locationManager.delegate = self
    }
    
    //MARK: FeedVC super class methods
    override func setUpTableView() {
        super.setUpTableView()
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        feedSearchBar.endEditing(true)
        let categoryViewModel = categoryDataSource.getCategoryViewModelFromIndexpath(indexPath)
        let categoryItemsFeedVC = CategoryItemsFeedVC()
        categoryItemsFeedVC.categoryViewModel = categoryViewModel
        self.navigationController?.pushViewController(categoryItemsFeedVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CategoryFeedVC: LocationManagerDelegate {
    
    func displayInVC(_ alertController: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}










