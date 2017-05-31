//
//  AutoCompleteResponse.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/29/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct AutoCompleteResponse: JSONDecodable {
    
    let terms: [AutoCompleteTerm]
    let businesses: [AutoCompleteBusiness]
    let categories: [AutoCompleteCategory]
    
    var content: [[JSONDecodable]] {
        return [self.businesses, self.terms, self.categories]
    }
    
    var titles: [String] {
        return ["Businesses", "Terms", "Categories"]
    }
}

extension AutoCompleteResponse {
    
    private struct Key {
        static let termsKey = "terms"
        static let businessesKey = "businesses"
        static let categoriesKey = "categories"
    }
    
    init(json: JSON) throws {
        
        let termsArray = json[Key.termsKey].arrayValue
        terms = try termsArray.decode()
        let businessArray = json[Key.businessesKey].arrayValue
        businesses = try businessArray.decode()
        let categoriesArray = json[Key.categoriesKey].arrayValue
        categories = try categoriesArray.decode()
    }
}


struct AutoCompleteTerm: JSONDecodable {
    let text: String
}

extension AutoCompleteTerm {
    
    private struct Key {
        static let textKey = "text"
    }
    
    init(json: JSON) throws {
        text = json[Key.textKey].stringValue
    }
}

struct AutoCompleteBusiness: JSONDecodable {
    
    let name: String
    let id: String
}

extension AutoCompleteBusiness {
    
    private struct Key {
        static let nameKey = "name"
        static let idKey = "id"
    }
    
    init(json: JSON) throws {
        name = json[Key.nameKey].stringValue
        id = json[Key.idKey].stringValue
    }
}

struct AutoCompleteCategory: JSONDecodable {
    
    let alias: String
    let title: String
}

extension AutoCompleteCategory {
    
    private struct Key {
        
        static let aliasKey = "alias"
        static let titleKey = "title"
    }
    
    init(json: JSON) throws {
        
        alias = json[Key.aliasKey].stringValue
        title = json[Key.titleKey].stringValue
    }
}
