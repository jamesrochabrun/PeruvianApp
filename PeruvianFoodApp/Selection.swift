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
struct Selection {
    
    init() {
    }
    var term: String?
    var categoryItems = [String]()
}


