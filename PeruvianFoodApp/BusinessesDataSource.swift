//
//  BusinessDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol BusinessViewModelDataSourceDelegate: class {
    func handleNoResults()
    func updateDataInMap()
}

class BusinessViewModelDataSource: NSObject, UITableViewDataSource, JSONDecodable {
    
    fileprivate var businessesViewModel: [BusinessViewModel] = [BusinessViewModel]()
    fileprivate var searchResults: [BusinessViewModel] = [BusinessViewModel]()
    fileprivate var searchActive : Bool = false
    weak var feedVC: FeedVC?
    weak var delegate: BusinessViewModelDataSourceDelegate?
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) throws {
        
        guard let businessesArray = json["businesses"].array else {
            throw NSError(domain: "com.yelp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Business JSON not valid structure"])
        }
        
        let businesses: [Business] = try businessesArray.decode()
        self.businessesViewModel = businesses.map{BusinessViewModel(model: $0)}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if businessesViewModel.count == 0 {
            self.delegate?.handleNoResults()
        } 
        return searchActive ? searchResults.count : businessesViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.feedVC?.delegate = self
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BusinesCell
        let businessViewModel = getBusinessViewModelFromIndexpath(indexPath)
        cell.setUpCell(with: businessViewModel)
        return cell
    }
}

//MARK: Helper methods
extension BusinessViewModelDataSource {
    
    func getBusinessViewModelFromIndexpath(_ indexPath: IndexPath) -> BusinessViewModel {
      return searchActive ? searchResults[indexPath.row] : businessesViewModel[indexPath.row]
    }
    
    func getBusinessesForMap() -> [BusinessViewModel] {
        return searchActive ? searchResults : businessesViewModel
    }
}

//MARK: this delegate handles all the updates in VC from tableview and mapview
extension BusinessViewModelDataSource: FeedVCDelegate {
    
    //Main delegate method of superclass FeedVC
    func updateDataInVC(_ vc: FeedVC) {
        searchActive = vc.searchActive
        delegate?.updateDataInMap()
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.businessesViewModel.filter({ (business) -> Bool in
            let businessNameToFind = business.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            //let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            //let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            return (businessNameToFind != nil) //|| (typeToFind != nil) || (locationToFind != nil)
        })
    }
}








