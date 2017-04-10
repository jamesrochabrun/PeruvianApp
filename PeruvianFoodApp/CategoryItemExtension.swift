//
//  CategoryExtension.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/7/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

extension CategoryItem {
    
    init?(dict: [String : AnyObject]) {
        
        guard let alias = dict[Key.categoryAliasKey] as? String,
            let title = dict[Key.categoryTitleKey] as? String,
            let parentsArray = dict[Key.categoryParentsKey] as? [String] else {
                return nil
        }
        self.alias = alias
        self.title = title
        self.parentsArray = parentsArray
    }
}



















