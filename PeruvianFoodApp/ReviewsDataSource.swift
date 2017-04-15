//
//  ReviewsDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import TRON
import SwiftyJSON


class ReviewsDataSource: NSObject, UITableViewDataSource, JSONDecodable {
    
    var reviews: [Review] = [Review]()
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) throws {
        
        guard let reviewsArray = json["reviews"].array else {
            throw NSError(domain: "com.yelp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Business JSON not valid structure"])
        }
        self.reviews = try reviewsArray.decode()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ReviewCell
        let review = reviews[indexPath.row]
        cell.review = review
        return cell
    }
}


