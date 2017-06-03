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

protocol BusinessViewModelDataSourceDelegate: class {
    func handleNoResults()
    func updateUIandData()
}

final class BusinessViewModelDataSource: NSObject, UITableViewDataSource, JSONDecodable {
    
    //MARK: Properties
    static let businessesKey = "businesses"
    fileprivate var businessesViewModel: [BusinessViewModel] = [BusinessViewModel]()
    fileprivate var searchResults: [BusinessViewModel] = [BusinessViewModel]()
    fileprivate var searchActive : Bool = false
    weak var searchVC: SearchVC?
    weak var delegate: BusinessViewModelDataSourceDelegate?
    
    //MARK: Initialization
    override init() {
        super.init()
    }
    
    required init(json: JSON) throws {
        
        guard let businessesArray = json[BusinessViewModelDataSource.businessesKey].array else {
            throw NSError(domain: "com.yelp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Business JSON not valid structure"])
        }
        
        let businesses: [Business] = try businessesArray.decode()
        self.businessesViewModel = businesses.map{ BusinessViewModel(model: $0) }
    }
    
    //MARK: TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if businessesViewModel.count == 0 {
            self.delegate?.handleNoResults()
        } 
        return searchActive ? searchResults.count : businessesViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.searchVC?.delegate = self
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BusinessCell
        let businessViewModel = getBusinessViewModelFrom(indexPath)
        cell.setUpCell(with: businessViewModel)
        return cell
    }
}

//MARK: Helper methods
extension BusinessViewModelDataSource {
    
    func getBusinessViewModelFrom(_ indexPath: IndexPath) -> BusinessViewModel {
      return searchActive ? searchResults[indexPath.row] : businessesViewModel[indexPath.row]
    }
    
    func getBusinessesForMap() -> [BusinessViewModel] {
        return searchActive ? searchResults : businessesViewModel
    }
}

//MARK: SearchVC delegation
extension BusinessViewModelDataSource: SearchVCDelegate {
    
    func updateDataInVC(_ vc: SearchVC) {
        
        searchActive = vc.searchActive
        delegate?.updateUIandData()
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.businessesViewModel.filter({ (business) -> Bool in
            let businessNameToFind = business.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            return (businessNameToFind != nil)
        })
    }
}








