//
//  AutoCompleteResultsDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class AutoCompleteResultsDataSource: NSObject, UITableViewDataSource {
    
    //MARK: Properties
    fileprivate var selection = Selection()
    fileprivate var autoCompleteResponse: AutoCompleteResponse?
    var tableView: UITableView?
    
    //MARK: initializers
    override init() {
        super.init()
    }
    
    //MARK: response updater
    func update(with response: AutoCompleteResponse) {
        autoCompleteResponse = response
    }
    
    //MARK: Tableview Datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCell
        //        if let response = autoCompleteResponse {
        //            let data: [JSONDecodable] = response.content[indexPath.section]
        //            cell.setUpWith(data: data, atIndex: indexPath.row)
        //        }
        
        guard let response = autoCompleteResponse else {
            print("HELP!!")
            return UITableViewCell()
        }
        

        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCell
            cell.accessoryType = .disclosureIndicator
            cell.autoCompleteTextLabel.text = responseViewModel.businesses[indexPath.row].name
            
            //cell.setBusinessImageViewFrom(id: responseViewModel.businesses[indexPath.row].id)
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCell
            cell.accessoryType = .disclosureIndicator
            cell.autoCompleteTextLabel.text = responseViewModel.terms[indexPath.row].text
            cell.businessImageView.image = nil
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCell
            cell.accessoryType = .disclosureIndicator
            cell.autoCompleteTextLabel.text = responseViewModel.categories[indexPath.row].title
            cell.businessImageView.image = nil
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteResponse != nil ? autoCompleteResponse!.content[section].count : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return autoCompleteResponse != nil ? autoCompleteResponse!.content.count : 0
    }
    
    //MARK: Helper method
    func getAutoCompleteResponse() -> AutoCompleteResponse? {
        return autoCompleteResponse
    }
}







