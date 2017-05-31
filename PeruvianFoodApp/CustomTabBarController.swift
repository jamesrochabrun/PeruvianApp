//
//  CustomTabBarController.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/25/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Colors.white.color
        tabBar.barTintColor = Colors.appMainColor.color
        
        let mainCategoryVC = MainCategoriesVC()
        let categoryNavController = UINavigationController(rootViewController: mainCategoryVC)
        categoryNavController.tabBarItem.title = "Nearby"
       // categoryNavController.tabBarItem.image = ""
        
        let autoCompleteVC = AutoCompleteVC()
        let autoCompleteVCNavController = UINavigationController(rootViewController: autoCompleteVC)
        autoCompleteVCNavController.tabBarItem.title = "Search"
        
        viewControllers = [categoryNavController, autoCompleteVCNavController]
    }
}
