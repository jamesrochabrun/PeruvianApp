//
//  CategoryItemViewModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

//MARK: this object holds the selection of the switch and provides the selected item to construct the selection object

struct SubCategoryViewModel {
    
    var itemTitle: String
    var itemAlias: String
    var isSelected: Bool
}

extension SubCategoryViewModel {
    
    init(subCategory: SubCategory) {
        self.itemTitle = subCategory.title
        self.itemAlias = subCategory.alias
        self.isSelected = false
    }
}

