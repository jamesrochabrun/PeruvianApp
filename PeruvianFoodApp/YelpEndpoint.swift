//
//  Endpoint.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

//MARK: Yelp enum to help endpoint creation

enum YelpEndpoint {
    case searchBusinesses
    case searchWith(id: String)
    case reviews(id: String)
    case token
}

extension YelpEndpoint {
    
    static var base: String {
        return "https://api.yelp.com/"
    }
    
    var path: String {
        switch self {
        case .searchBusinesses:
            return "v3/businesses/search"
        case .searchWith(let id):
            return "v3/businesses/\(id)"
        case .reviews(let id):
            return "v3/businesses/\(id)/reviews"
        case .token:
            return "oauth2/token"
        }
    }
}


























