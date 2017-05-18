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

//MARK: Reference 
//API returns 3 reviews
//https://www.yelp.es/developers/documentation/v3/business_reviews

struct Review: JSONDecodable {
    
    let rating: NSNumber
    let user: User
    let text: String
    let reviewURL: String
    let timeCreated: String
}

extension Review {
    
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

//MARK: User that wrote the review
struct User: JSONDecodable {
    
    var imageProfileURL: String?
    let name: String
}

extension User {
    
    private struct Key {
        static let imageProfileKey = "image_url"
        static let nameKey = "name"
    }
    
    init(json: JSON) throws {
        imageProfileURL = json[Key.imageProfileKey].stringValue
        name = json[Key.nameKey].stringValue
    }
}

