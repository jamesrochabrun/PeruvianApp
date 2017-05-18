//
//  HoursModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/17/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

//MARK: reference
//https://www.yelp.es/developers/documentation/v3/business

//MARK: Hours Model
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

//MARK: OpenSchedule Model
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




