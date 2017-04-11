//
//  BusinessModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import TRON

//MARK: Main Object for Business
struct Business: JSONDecodable {
    
    let businessID: String
    let name: String
    let rating: NSNumber
    let price: String
    let imageURL: String
    let phone: String
    let is_closed: Bool
    let reviewsCount: NSNumber
    let url: String
    let categories: [CategoryItem]
    let distance: NSNumber
    let location: Location
    let coordinates: Coordinates
    var photos: [Any]?
    
    private struct Key {
        
        static let idKey = "id"
        static let namekey = "name"
        static let ratingKey = "rating"
        static let priceKey = "price"
        static let imageURLKey = "image_url"
        static let phoneKey = "phone"
        static let is_closedKey = "is_closed"
        static let reviewsCountKey = "review_count"
        static let urlKey = "url"
        static let categoriesKey = "categories"
        static let distanceKey = "distance"
        static let transactionsKey = "transactions"
        static let locationKey = "location"
        static let coordinatesKey = "coordinates"
        static let photosKey = "photos"
    }
    
    init(json: JSON) throws {
        
        businessID = json[Key.idKey].stringValue
        name = json[Key.namekey].stringValue
        rating = json[Key.ratingKey].numberValue
        price = json[Key.priceKey].stringValue
        imageURL = json[Key.imageURLKey].stringValue
        phone = json[Key.phoneKey].stringValue
        is_closed = json[Key.is_closedKey].boolValue
        reviewsCount = json[Key.reviewsCountKey].numberValue
        url = json[Key.urlKey].stringValue
        let categoryArray =  json[Key.categoriesKey].arrayValue
        categories = try categoryArray.decode()
        distance = json[Key.distanceKey].numberValue
        location = try Location(json: json[Key.locationKey])
        coordinates = Coordinates(json: json[Key.coordinatesKey])
        photos = json[Key.photosKey].arrayObject
    }
}

//MARK: Categories object
struct CategoryItem: JSONDecodable {
    
    let alias: String
    let title: String
    var parentsArray: [String]?
    
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

//MARK: Location object
struct Location: JSONDecodable {
    
    let city: String
    let country: String
    let address1: String
    let address2: String
    let address3: String
    let state: String
    let zip_code: String
    
    private struct Key {
        static let locationCityKey = "city"
        static let locationCountryKey = "country"
        static let locationAdd1Key = "address1"
        static let locationAdd2Key = "address2"
        static let locationAdd3Key = "address3"
        static let locationStateKey = "state"
        static let locationZipKey = "zip_code"
    }
    
    init(json: JSON) throws {
        city = json[Key.locationCityKey].stringValue
        country = json[Key.locationCountryKey].stringValue
        address1 = json[Key.locationAdd1Key].stringValue
        address2 = json[Key.locationAdd2Key].stringValue
        address3 = json[Key.locationAdd3Key].stringValue
        state = json[Key.locationStateKey].stringValue
        zip_code = json[Key.locationZipKey].stringValue
    }
}

//MARK: Coordinates object 
struct Coordinates: JSONDecodable {
    
    let latitude: NSNumber
    let longitude: NSNumber
    
    private struct  Key {
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
    }
    
    init(json: JSON) {
        latitude = json[Key.latitudeKey].numberValue
        longitude = json[Key.longitudeKey].numberValue
    }
}







































