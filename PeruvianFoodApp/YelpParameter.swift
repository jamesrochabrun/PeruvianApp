//
//  YelpParameter.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

enum YelpParameter {
    
    case nearbyFrom(selection: Selection)
    case token
}

extension YelpParameter {
    
    //THIS INFORMATION MUST BE SAVED ON KEYCHAIN ON PRODUCTION.
    static var accessToken: String {
        return "mS62uF4nkSmm0MDETma145S_DH3eNk12GpuJa9IpxBdBfHJbDjNfFbIp_90kwNhmQzKe70-7tVUMAt_el2gqoGza5xu4N20EhgMxPTO_GSHn9qNSUkC8KEXZBQPlWHYx"
    }
    
    private struct ClientData {
        static let clientSecret = "uzW9fTnBTuOEvzb3bPx1aHMxR5ADq76RK7WMeyyznwgAETUTqq5M9l4Uw2q2TSyL"
        static let clientID = "2f5-nq6WiXCN89EdEo6j9Q"
        static let clientType = "grant_type"
    }
    /////////////////////////////////////////////////////////////
    
    private struct Key {
        
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let categories = "categories"
        static let price = "price"
        static let radius = "radius"
        static let sort_by = "sort_by"
        static let client_id = "client_id"
        static let client_secret = "client_secret"
        static let clientType = "client_credentials"
    }
    
    var paramaters: [String: Any] {
        
        var parametersDictionary: [String: Any] = [:]
        switch self {
        case .nearbyFrom(let selection):
            let selectionParameters = SelectionParameters(selection: selection)
            parametersDictionary[YelpParameter.Key.latitude] = selectionParameters.latitude
            parametersDictionary[YelpParameter.Key.longitude] = selectionParameters.longitude
            parametersDictionary[YelpParameter.Key.categories] = selectionParameters.categories
            parametersDictionary[YelpParameter.Key.radius] = selectionParameters.radius
            parametersDictionary[YelpParameter.Key.price] = selectionParameters.price
            parametersDictionary[YelpParameter.Key.sort_by] = "distance"
        case .token:
            parametersDictionary[YelpParameter.Key.client_id] = YelpParameter.ClientData.clientID
            parametersDictionary[YelpParameter.Key.client_secret] = YelpParameter.ClientData.clientSecret
            parametersDictionary[YelpParameter.Key.clientType] = YelpParameter.ClientData.clientType
        }
        return parametersDictionary
    }
}

//MARK: Creating a formatted version of Selection class
struct SelectionParameters {
    
    var categories: String
    var price: String
    var radius: Int
    var latitude: String
    var longitude: String
}

extension SelectionParameters {
    
    init(selection: Selection) {
        
        categories = selection.categoryItems.count <= 0 ? selection.mainCategory.rawValue : selection.categoryItems.joined(separator: ",")
        price = selection.price != nil ? selection.price!.rawValue : ""
        radius = selection.radius != nil ? selection.radius!.rawValue : 20000 //default distance
        latitude = selection.coordinates?.latitude != nil ? String(describing: selection.coordinates!.latitude) : "37.785771"
        longitude = selection.coordinates?.longitude != nil ? String(describing: selection.coordinates!.longitude) : "-122.406165" //default to San Francisco
    }
}



