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


class ReviewsViewModelDataSource: NSObject, UITableViewDataSource, JSONDecodable {
    
    //MARK: Properties
    static let reviewsKey = "reviews"
    private var reviewsViewModel: [ReviewViewModel] = [ReviewViewModel]()
    
    //MARK: initializers
    override init() {
        super.init()
    }
    
    required init(json: JSON) throws {
        
        guard let reviewsArray = json[ReviewsViewModelDataSource.reviewsKey].array else {
            throw NSError(domain: "com.yelp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Business JSON not valid structure"])
        }
        let reviews: [Review] = try reviewsArray.decode()
        self.reviewsViewModel = reviews.map{ReviewViewModel(review: $0)}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ReviewCell
        let reviewViewModel = reviewsViewModel[indexPath.row]
        cell.setUp(with: reviewViewModel)
        return cell
    }
}


