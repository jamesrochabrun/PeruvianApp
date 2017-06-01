//
//  AutoCompleteResponseDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class AutoCompleteResponseDataSource: NSObject, UITableViewDataSource {
    
    //MARK: Properties
    fileprivate var selection = Selection()
    fileprivate var autoCompleteResponse: AutoCompleteResponse?
    
    //MARK: initializers
    override init() {
        super.init()
    }
    
    //MARK: response updater
    func update(with response: AutoCompleteResponse?){
        autoCompleteResponse = response
    }
    
    //MARK: Tableview Datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCell
            if let autoCompleteBusiness = autoCompleteResponse?.businesses[indexPath.row] {
                cell.setUpWith(autoCompleteBusiness)
            }
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCellText
            if let autoCompleteTerms = autoCompleteResponse?.terms[indexPath.row] {
                cell.setUpText(with: autoCompleteTerms.text)
            }
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AutoCompleteBusinessCellText
            if let autoCompleteCategories = autoCompleteResponse?.categories[indexPath.row] {
                cell.setUpText(with: autoCompleteCategories.title)
            }
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



