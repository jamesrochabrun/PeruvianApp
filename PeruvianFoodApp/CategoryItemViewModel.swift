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

struct CategoryItemViewModel {
    
    var itemTitle: String
    var itemAlias: String
    var isSelected: Bool
    
    init(categoryItem: CategoryItem) {
        self.itemTitle = categoryItem.title
        self.itemAlias = categoryItem.alias
        self.isSelected = false
    }
}

