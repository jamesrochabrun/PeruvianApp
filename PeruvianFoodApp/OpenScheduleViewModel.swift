//
//  OpenScheduleViewModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


struct HoursViewModel {
    
    let hoursType: String
    let isOpenNow: String
}

extension HoursViewModel {
    
    init(hours: Hours) {
        hoursType = hours.hours_type.lowercased()
        isOpenNow = hours.is_openNow ? "Open" : "Closed"
    }
}

struct OpenScheduleViewModel {
    
    let is_overnight: String
    let end: String
    let day: String
    let start: String
}

//MARK: Creating a initializer in an extension to avoid override the struct memberwise initializer
extension OpenScheduleViewModel {
    
    init(schedule: OpenSchedule) {
        
        is_overnight =  schedule.is_overnight ? "Overnight" : ""
        let dayOfTheWeek = DayOfTheWeek(dayNumber: schedule.day)
        day = dayOfTheWeek.dayPresentable
        end = String(describing: schedule.end)
        start = String(describing: schedule.start)
    }
}

//MARK: enum that handles the day of the week in string format based on a number input
enum DayOfTheWeek: NSNumber {
    
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    case unexpectedDay
    
    init(dayNumber: NSNumber) {
        
        switch dayNumber {
        case 0: self = .monday
        case 1: self = .tuesday
        case 2: self = .wednesday
        case 3: self = .thursday
        case 4: self = .friday
        case 5: self = .saturday
        case 6: self = .sunday
        default: self = .unexpectedDay
        }
    }
}

extension DayOfTheWeek {
    
    var dayPresentable: String {
        
        switch  self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        case .unexpectedDay: return ""
            
        }
    }
}















