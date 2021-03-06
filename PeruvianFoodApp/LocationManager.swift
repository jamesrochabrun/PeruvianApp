//
//  LocationManager.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


protocol LocationManagerDelegate: class {
    func displayInVC(_ alertController: UIAlertController)
}


class LocationManager: NSObject {
    
    let manager = CLLocationManager()
    var locationTextable: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    fileprivate func displayAlertAskingFoUserPermission() {
        
        let alertController = UIAlertController(title: "This app needs access to your location", message: "Allow to show you the best options around you!", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Not Now", style: .cancel)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if self.manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                self.manager.requestWhenInUseAuthorization()
            } else if self.manager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
                self.manager.requestAlwaysAuthorization()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        delegate?.displayInVC(alertController)
    }
    
    func displayAlertIfAuthorizationIsDenied() {
        
        let alertController = UIAlertController(title: "This app needs access to your location", message: "Go to your settings and allow to share your location", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            kAppSettings.openSettings(.kAppSettingsLocation)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        delegate?.displayInVC(alertController)
    }

}

extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("user still thinking granting location access")
            manager.startUpdatingLocation()
            displayAlertAskingFoUserPermission()
        case .denied:
            print("User denied acces to location")
            displayAlertIfAuthorizationIsDenied()
            manager.stopUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Yes located")
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        guard let location = locations.first else {
            print("No location return")
            return
        }
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let placemark = placemarks?.first {
                self.locationTextable = placemark.name ?? ""
                self.longitude = placemark.location?.coordinate.longitude ?? 0
                self.latitude = placemark.location?.coordinate.latitude ?? 0
            }
        }
    }
}




















