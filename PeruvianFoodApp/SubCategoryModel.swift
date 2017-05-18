//
//  CategoryExtension.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/7/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import TRON
import SwiftyJSON

struct SubCategory: JSONDecodable {
    
    let alias: String
    let title: String
    var parentsArray: [String]?
}


extension SubCategory {
    
    struct Key {
        static let categoryAliasKey = "alias"
        static let categoryTitleKey = "title"
        static let categoryParentsKey = "parents"
    }
    
    init(json: JSON) throws {
        alias = json[Key.categoryAliasKey].stringValue
        title = json[Key.categoryTitleKey].stringValue
    }
}

extension SubCategory {
    
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



















