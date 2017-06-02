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
    func getCoordinates(_ coordinates: Coordinates)
}

class LocationManager: NSObject {
    
    //MARK: properties
    let manager = CLLocationManager()
    var locationTextable: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    weak var delegate: LocationManagerDelegate?
    
    //MARK: Initialization
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    //MARK: User access permission
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

//MARK: CLLocationManagerDelegate methods
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
       // manager.delegate = nil
        guard let location = locations.first else {
            print("No location returned")
            return
        }
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            
            guard let strongSelf = self else {
                print("SELF IS BEEN DEALLOCATED ON GEOCODER CALL")
                return
            }
            if let placemark = placemarks?.first {
                strongSelf.locationTextable = placemark.name ?? ""
                strongSelf.longitude = placemark.location?.coordinate.longitude ?? 0
                strongSelf.latitude = placemark.location?.coordinate.latitude ?? 0
                let coordinates = Coordinates(latitude: NSNumber(value: strongSelf.latitude), longitude: NSNumber(value: strongSelf.longitude))
                strongSelf.delegate?.getCoordinates(coordinates)
                
            }
        }
    }
}




















