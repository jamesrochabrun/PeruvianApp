//
//  YelpHeader.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

enum YelpHeader {
    
    case authorization
    case contentType
}

extension YelpHeader {
    
    private struct Key {
        static let authorizationKey = "Authorization"
        static let contentTypeKey = "Content-Type"
    }
    
    var headers : [String: String] {
        var headersDictionary: [String: String] = [:]
        switch self {
        case .authorization:
            headersDictionary[YelpHeader.Key.authorizationKey] = "Bearer \(YelpParameter.accessToken)"
        case .contentType:
            headersDictionary[YelpHeader.Key.contentTypeKey] = "application/x-www-form-urlencoded"
        }
        return headersDictionary
    }
}
