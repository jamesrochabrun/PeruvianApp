//
//  MainCategoryModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/17/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

//MARK: Main categories, default to restaurants
enum MainCategory: String {
    
    case restaurants
    case bars
    case food
    
    static var categories: [MainCategory] {
        return [.restaurants, .bars, .food]
    }
    
    init() {
        self = .restaurants
    }
}
