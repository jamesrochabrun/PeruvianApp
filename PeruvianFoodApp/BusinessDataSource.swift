//
//  BusinessDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import TRON

class BusinessDataSource:NSObject, UITableViewDataSource, JSONDecodable {
    
    var businesses: [Business] = [Business]()
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) throws {
        
        guard let businessesArray = json["businesses"].array else {
            throw NSError(domain: "com.yelp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Business JSON not valid structure"])
        }
        self.businesses = try businessesArray.decode()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BusinesCell
        let business = businesses[indexPath.item]
        let businessViewModel = BusinessCellViewModel(model: business, at: indexPath.item)
        cell.businessCellViewModel = businessViewModel
        return cell
    }
}


