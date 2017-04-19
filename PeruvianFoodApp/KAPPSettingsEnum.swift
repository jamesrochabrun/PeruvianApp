//
//  KAPPSettingsEnum.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

enum kAppSettings {
    
    case kAppSettingsPhotos
    case kAppSettingsCamera
    case kAppSettingsLocation
    case kAppSettingsContacts
    
    var path: String {
        switch self {
        case .kAppSettingsPhotos:
            return "prefs:root=Privacy&path=PHOTOS"
        case .kAppSettingsCamera:
            return "prefs:root=Privacy&path=CAMERA"
        case .kAppSettingsLocation:
            return "prefs:root=LOCATION_SERVICES"
        case . kAppSettingsContacts:
            return "prefs:root=Privacy&path=CONTACTS"
        }
    }
    
    static func openSettings(_ settings: kAppSettings) {
        
        if let url = URL(string: settings.path) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            } else {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:])
            }
        }
    }
}
