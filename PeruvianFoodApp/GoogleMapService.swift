//
//  GoogleMapService.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import GoogleMaps

struct GoogleMapService {
    
    static let baseURL = "https://maps.googleapis.com/maps/api/directions/json?"
    static let directionApiKey = "AIzaSyBmzgXL-DHK4Iq9sYqqZSH8cHrxW18Popk"
    
    typealias DirectionsCompletionHandler = (GoogleResult<GMSPath>) -> Void
    
    static func getDirectionsFrom(mapView: GMSMapView, marker: GMSMarker, completion: @escaping DirectionsCompletionHandler) {
        
        guard let startLatitude = mapView.myLocation?.coordinate.latitude, let startLongitude = mapView.myLocation?.coordinate.longitude else {
            completion(.Error(.locationServiceDisable))
            return
        }
        let startLocation = "\(startLatitude),\(startLongitude)"
        let endlocation = "\(marker.position.latitude),\(marker.position.longitude)"
        let urlString = "\(GoogleMapService.baseURL)origin=\(startLocation)&destination=\(endlocation)&sensor=true&key=\(GoogleMapService.directionApiKey)"
                
        if let url = URL(string: urlString) {
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                
                if response.response?.statusCode == 200 {
                    
                    if let json = response.result.value as? [String: AnyObject], let status = json["status"] as? String {
                        
                        if status == "OK" {
                            
                            if let routes = json["routes"] as? [[String: AnyObject]],
                                let firstRoute = routes.first,
                                let polyline = firstRoute["overview_polyline"] as? [String: AnyObject],
                                let points = polyline["points"] as? String {
                                
                                if  let path = GMSPath.init(fromEncodedPath: points) {
                                    completion(.Success(path))
                                } else {
                                    completion(.Error(.invalidPath))
                                }
                            } else {
                                completion(.Error(.pointsNotFoundedError))
                            }
                        } else {
                            completion(.Error(.statusFailure))
                        }
                    } else {
                        completion(.Error(.invalidJSON))
                    }
                } else {
                    completion(.Error(.statusCodeNot200))
                }
            })
        } else {
            completion(.Error(.invalidURL))
        }
    }
}

enum GoogleResult<T>{
    case Success(T)
    case Error(GoogleError)
}

enum GoogleError: Error {
    case invalidURL
    case invalidJSON
    case statusCodeNot200
    case statusFailure
    case pointsNotFoundedError
    case invalidPath
    case locationServiceDisable
}



