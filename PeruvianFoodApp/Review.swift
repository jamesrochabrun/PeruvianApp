//
//  ReviewModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import TRON

struct Review: JSONDecodable {
    
    let rating: NSNumber
    let user: User
    let text: String
    let reviewURL: String
    let timeCreated: String
    
    private struct Key {
        static let ratingKey = "rating"
        static let userKey = "user"
        static let textKey = "text"
        static let reviewURLKey = "url"
        static let timeCreatedKey = "time_created"
    }
    
    init(json: JSON) throws {
        
        rating = json[Key.ratingKey].numberValue
        user =  try User(json: json[Key.userKey])
        text = json[Key.textKey].stringValue
        reviewURL = json[Key.reviewURLKey].stringValue
        timeCreated = json[Key.timeCreatedKey].stringValue
    }
}

struct User: JSONDecodable {
    
    var imageProfileURL: String?
    let name: String
    
    private struct Key {
        static let imageProfileKey = "image_url"
        static let nameKey = "name"
    }
    
    init(json: JSON) throws {
        imageProfileURL = json[Key.imageProfileKey].stringValue
        name = json[Key.nameKey].stringValue
    }
}

