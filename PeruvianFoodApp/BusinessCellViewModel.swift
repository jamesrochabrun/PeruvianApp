//
//  BusinessCellViewModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

struct BusinessCellViewModel {
    
    let name: String
    let reviewsCount: String
    let price: String
    let address: String
    let distance: String
    let category: String
    var profileImageURL: String
    
    init(model: Business, at index: Int) {
        
        name = "\(index + 1) \(model.name)"
        reviewsCount = "\(model.reviewsCount) Reviews"
        price = model.price
        address = model.location.address1 + ", " + model.location.city
        let d = CGFloat(model.distance) / 1000.0
        distance = String(format: "%.2f mi", d)
        if let category = model.categories.first {
            self.category = category.title
        } else {
            self.category = "No category"
        }
        profileImageURL = model.imageURL
    }
}




