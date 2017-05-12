//
//  CustomTabBar.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        let nearbyVC = NearbyVC()
        let nearbyNavController = UINavigationController(rootViewController: nearbyVC)
        nearbyNavController.tabBarItem.title = "Nearby"
        
        let categoryVC = CategoryFeedVC()
        let categoryNavController = UINavigationController(rootViewController: categoryVC)
        categoryNavController.tabBarItem.title = "Categories"
        
        viewControllers = [nearbyNavController, categoryNavController]
    }
    
    
    

}

