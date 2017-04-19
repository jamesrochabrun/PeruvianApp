//
//  BundleDonwnloader.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/6/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct JSONDownloader {
    
    typealias JSON = [[String: AnyObject]]
    typealias JSONTaskCompletionHandler = (BundleResult<[CategoryItem?]>) -> Void
    
    func jsonTaskFrom(path: String, completionHandler completion: @escaping JSONTaskCompletionHandler) {
        
        if let content = NSData.init(contentsOfFile: path) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: content as Data, options: []) as? [[String: AnyObject]] {
                    let categoryArray = jsonArray.map{CategoryItem(dict: $0)}
                    completion(.Success(categoryArray))
                }
            } catch {
                completion(.Error(.invalidJSON))
            }
        }
    }
}

enum BundleResult<T>{
    case Success(T)
    case Error(PathError)
}

enum PathError: Error {
    case invalidPath
    case invalidJSON
}

struct CategoryService {
    
    let downloader = JSONDownloader()
    
    typealias CategoryCompletionHandler = (BundleResult<[CategoryItem?]>) -> Void
    
    func get(completion: @escaping CategoryCompletionHandler) {
        
        guard let filePath = Bundle.main.path(forResource: "categories", ofType: "json") else {
            completion(.Error(.invalidPath))
            return
        }
        downloader.jsonTaskFrom(path: filePath) { (result) in
            switch result {
            case .Success(let jsonArray):
                DispatchQueue.main.async {
                    completion(.Success(jsonArray))
                }
            case .Error(let error):
                print(error)
                completion(.Error(error))
            }
        }
    }
}

import GoogleMaps

enum GoogleResult<T>{
    case Success(T)
    case Error(GoogleError)
}

enum GoogleError: Error {
    case invalidURL
    case invalidJSON
    case statusCodeNot200
    case statusFailure
}

struct GoogleMapService {
    
    static let baseURL = "https://maps.googleapis.com/maps/api/directions/json?"
    static let directionApiKey = "AIzaSyBmzgXL-DHK4Iq9sYqqZSH8cHrxW18Popk"
    
    typealias DirectionsCompletionHandler = (GoogleResult<GMSPath>) -> Void
    
    static func getDirectionsFrom(mapView: GMSMapView, marker: GMSMarker, completion: @escaping DirectionsCompletionHandler) {
        
        guard let startLatitude = mapView.myLocation?.coordinate.latitude, let startLongitude = mapView.myLocation?.coordinate.longitude else {
            print("NO starting point of user")
            return
        }
        let startLocation = "\(startLatitude),\(startLongitude)"
        let endlocation = "\(marker.position.latitude),\(marker.position.longitude)"
        let urlString = "\(GoogleMapService.baseURL)origin=\(startLocation)&destination=\(endlocation)&sensor=true&key=\(GoogleMapService.directionApiKey)"
        
        print(urlString)
        
        if let url = URL(string: urlString) {
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                
                if response.response?.statusCode == 200 {
               
                    if let json = response.result.value as? [String: AnyObject], let status = json["status"] as? String {
                        
                        if status == "OK" {
                            
                            
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


















