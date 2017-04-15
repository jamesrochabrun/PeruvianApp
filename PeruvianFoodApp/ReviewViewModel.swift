//
//  ReviewViewModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

struct ReviewViewModel {
    
    let ratingImage: UIImage
    let userName: String
    let profileImageURL: URL?
    let timeCreated: String
    let text: String
    let reviewURL: URL?
}

extension ReviewViewModel {
    
    init(review: Review) {
        
        ratingImage = ReviewIcon(reviewNumber: review.rating).image
        userName = review.user.name
        if let profileURL = review.user.imageProfileURL {
            profileImageURL = URL(string: profileURL)
        } else {
            profileImageURL = nil
        }
        timeCreated = review.timeCreated
        text = review.text
        reviewURL = URL(string: review.reviewURL)
    }
}
