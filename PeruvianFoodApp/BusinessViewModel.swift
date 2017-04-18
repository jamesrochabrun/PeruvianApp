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
import TRON
import SwiftyJSON


//let businessID: String
//let name: String
//let rating: NSNumber
//let price: String
//let imageURL: String
//let phone: String
//let is_closed: Bool
//let reviewsCount: NSNumber
//let url: String
//let categories: [CategoryItem]
//let distance: NSNumber
//let location: Location
//let coordinates: Coordinates

struct BusinessViewModel {
    
    let name: String
    let businessID: String
    let reviewsCount: String
    let price: String
    let address: String
    var distance: String
    let category: String
    var profileImageURL: String
    var ratingImage: UIImage
    var isClosed: Bool
    var photos: [String]?
    var coordinates: Coordinates
    var textRating: String
    let phone: String
    let hours: [Hours]?
}

extension BusinessViewModel {
    
    init(model: Business) {
        
        name = model.name
        businessID = model.businessID
        reviewsCount = "\(model.reviewsCount) Reviews"
        price = model.price
        address = model.location.address1 != "" ? model.location.address1 + ", " + model.location.city : model.location.city
        let d = CGFloat(model.distance) / 1000.0
        distance = String(format: "%.2f mi", d)
        if let category = model.categories.first {
            self.category = category.title
        } else {
            self.category = "No category"
        }
        profileImageURL = model.imageURL
        ratingImage = ReviewIcon(reviewNumber: model.rating).image
        isClosed = model.is_closed
        coordinates = model.coordinates
        photos = model.photos as? [String]
        textRating = String(describing: model.rating)
        phone = model.phone != "" ? model.phone : "No phone"
        hours = model.hours
    }
}

enum ReviewIcon: NSNumber {
    
    case zeroStar
    case oneStar
    case oneAndHalfStar
    case twoStar
    case twoAndHalfStar
    case threeStar
    case threeAndHalfStar
    case fourStar
    case fourAndHalfStar
    case fiveStar
    case unexpectedReview
    
    init(reviewNumber: NSNumber) {
        
        switch reviewNumber {
        case 0 : self = .zeroStar
        case 1 : self = .oneStar
        case 1.5: self = .oneAndHalfStar
        case 2 : self = .twoStar
        case 2.5 : self = .twoAndHalfStar
        case 3 : self = .threeStar
        case 3.5 : self = .threeAndHalfStar
        case 4 : self = .fourStar
        case 4.5 : self = .fourAndHalfStar
        case 5 : self = .fiveStar
        default: self = .unexpectedReview
        }
    }
}

extension ReviewIcon {
    
    var image : UIImage {
        switch self {
        case .zeroStar: return #imageLiteral(resourceName: "large_0")
        case .oneStar: return #imageLiteral(resourceName: "large_1")
        case .oneAndHalfStar: return #imageLiteral(resourceName: "large_1_half")
        case .twoStar: return #imageLiteral(resourceName: "large_2")
        case .twoAndHalfStar: return #imageLiteral(resourceName: "large_2_half")
        case .threeStar: return #imageLiteral(resourceName: "large_3")
        case .threeAndHalfStar: return #imageLiteral(resourceName: "large_3_half")
        case .fourStar: return #imageLiteral(resourceName: "large_4")
        case .fourAndHalfStar: return #imageLiteral(resourceName: "large_4_half")
        case .fiveStar: return #imageLiteral(resourceName: "large_5")
        case .unexpectedReview: return #imageLiteral(resourceName: "large_0")
        }
    }
}

//struct DistanceViewModel {
//    var distancePresentable: String
//    init(business: Business) {
//        let d = CGFloat(business.distance) / 1000.0
//        distancePresentable = String(format: "%.2f mi", d)
//    }
//}
//
//
//








