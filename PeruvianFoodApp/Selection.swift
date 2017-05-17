//
//  Selection.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

//MARK: this object is created based in different parameters its passed by dependency inhection through view controllers and finally passed as an argument to the API call.
class Selection {
    
    init() {
    }
    var term: String = ""
    var mainCategory: MainCategory = MainCategory()
    var categoryItems = [String]()
    var radius: Radius?
    var price: Price?
}

enum Radius: Int {
    
    case fiveMiles = 8000
    case tenMiles = 16000
    case fifteenMiles = 24000
    case twentyMiles = 32000
}

enum Price: String {
    
    case oneDollarIcon = "1"
    case twoDollarIcon = "2"
    case threeDollarIcon = "3"
    case fourDollarIcon = "4"
}

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


