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

class BusinessDataSource: NSObject, UITableViewDataSource, JSONDecodable {
    
    var businesses: [Business] = [Business]()
    var searchResults: [Business] = []
    var searchActive : Bool = false
    var feedVC: FeedVC?
    
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
        return searchActive ? searchResults.count : businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.feedVC?.delegate = self
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BusinesCell
        let business = searchActive ? searchResults[indexPath.row] : businesses[indexPath.row]
        let businessViewModel = BusinessCellViewModel(model: business, at: indexPath.item)
        cell.businessCellViewModel = businessViewModel
        return cell
    }
}

extension BusinessDataSource: FeedVCDelegate {
    
    func updateDataInVC(_ vc: FeedVC) {
        searchActive = vc.searchActive
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.businesses.filter({ (business) -> Bool in
            let businessNameToFind = business.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            //let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            //let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return (businessNameToFind != nil) //|| (typeToFind != nil) || (locationToFind != nil)
        })
    }
}
