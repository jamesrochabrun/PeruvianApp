//
//  CategoryFeedVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class MainCategoriesVC: SearchVC {
    
    //MARK: Properties
    let dataSource = MainCategoriesDataSource()
    let locationManager = LocationManager()
    
    //MARK: APP lyfecycle
    override func viewDidLoad() {
        
        setUpNavBar()
        setUpTableView()
        locationManager.delegate = self
    }
    
    //MARK: FeedVC super class methods
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.register(CategoryCell.self)
        tableView.dataSource = dataSource
        dataSource.mainCategoriesVC = self
    }
}

//MARK: tableview delegate
extension MainCategoriesVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        feedSearchBar.endEditing(true)
        let mainCategoryViewModel = dataSource.getMainCategoryViewModelFrom(indexPath)
        let subCategoriesVC = SubCategoriesVC()
        subCategoriesVC.mainCategoryViewModel = mainCategoryViewModel
        self.navigationController?.pushViewController(subCategoriesVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MainCategoriesVC: LocationManagerDelegate {
    
    func displayInVC(_ alertController: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}










