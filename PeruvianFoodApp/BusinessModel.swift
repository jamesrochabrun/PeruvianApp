//
//  BusinessModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

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
    var hours: [Hours]?
}

extension Business {
    
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
        static let hoursKey = "hours"
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
        let hoursArray = json[Key.hoursKey].arrayValue
        hours = try hoursArray.decode()
    }
}

//MARK: Categories object
struct CategoryItem: JSONDecodable {
    
    let alias: String
    let title: String
    var parentsArray: [String]?
}

extension CategoryItem {
    
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
}

extension Location {
    
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
}

extension Coordinates {
    
    private struct  Key {
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
    }
    
    init(json: JSON) {
        latitude = json[Key.latitudeKey].numberValue
        longitude = json[Key.longitudeKey].numberValue
    }
}

//MARK: Hours object
struct Hours: JSONDecodable {
    
    let hours_type: String
    let open: [OpenSchedule]
    let is_openNow: Bool
}

extension Hours {
    
    private struct Key {
        static let hours_typeKey = "hours_type"
        static let openKey = "open"
        static let is_openNowKey = "is_open_now"
    }
    
    init(json: JSON) throws {
        
        hours_type = json[Key.hours_typeKey].stringValue
        let openScheduleArray = json[Key.openKey].arrayValue
        open = try openScheduleArray.decode()
        is_openNow = json[Key.is_openNowKey].boolValue
    }
}

struct OpenSchedule: JSONDecodable {

    let is_overnight: Bool
    let end: NSNumber
    let day: NSNumber
    let start: NSNumber
}

extension OpenSchedule {
    
    private struct Key {
        static let is_overnightKey = "is_overnight"
        static let endKey = "end"
        static let daykey = "day"
        static let startKey = "start"
    }
    
    init(json: JSON) throws {
        
        is_overnight = json[Key.is_overnightKey].boolValue
        end = json[Key.endKey].numberValue
        day = json[Key.daykey].numberValue
        start = json[Key.startKey].numberValue
    }
}














