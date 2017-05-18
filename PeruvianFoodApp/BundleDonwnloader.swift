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
    typealias JSONTaskCompletionHandler = (BundleResult<[SubCategory?]>) -> Void
    
    func jsonTaskFrom(path: String, completionHandler completion: @escaping JSONTaskCompletionHandler) {
        
        if let content = NSData.init(contentsOfFile: path) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: content as Data, options: []) as? [[String: AnyObject]] {
                    let categoryArray = jsonArray.map{ SubCategory(dict: $0) }
                    completion(.Success(categoryArray))
                }
            } catch {
                completion(.Error(.invalidJSON))
            }
        }
    }
}

struct CategoryService {
    
    let downloader = JSONDownloader()
    
    typealias CategoryCompletionHandler = (BundleResult<[SubCategory?]>) -> Void
    
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

enum BundleResult<T>{
    case Success(T)
    case Error(PathError)
}

enum PathError: Error {
    case invalidPath
    case invalidJSON
}

















