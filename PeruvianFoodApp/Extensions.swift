//
//  Extensions.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON


//MARK: this generic method maps an array of json objects that conform to JSONDecodable and return an array of instantiated objects

extension Collection where Iterator.Element == JSON {
    func decode<T: JSONDecodable>() throws -> [T] {
        return try map{ try T(json: $0)}
    }
}

extension Notification.Name {
   //static let successDataNotification = Notification.Name("dataSuccess")
    static let dismissViewNotification = Notification.Name("dismiss")
}
