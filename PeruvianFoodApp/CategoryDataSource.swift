//
//  CategoryDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryDataSourceDelegate: class {
    func updateDataInVC()
}

class CategoryDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: CategoryDataSourceDelegate?
    var categoriesViewModelArray = [CategoryViewModel]() {
        didSet {
            delegate?.updateDataInVC()
        }
    }
    var searchResults = [CategoryViewModel]()
    var searchActive : Bool = false
    //binding the delegate on creation this delegate is in charge of the searchbar
    weak var categoryFeedVC: CategoryFeedVC? {
        didSet {
            self.categoryFeedVC?.delegate = self
        }
    }
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        
        let categoryViewModel = CategoryViewModel()
        categoryViewModel.getAllCategoriesAsViewModel { (array) in
            self.categoriesViewModelArray = array
        }
    }
    
    func getCategoriesArray() -> [CategoryViewModel] {
        return categoriesViewModelArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCell
        cell.listNameLabel.text = searchActive ? searchResults[indexPath.row].categoryListTitle : categoriesViewModelArray[indexPath.row].categoryListTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? searchResults.count : categoriesViewModelArray.count
    }
}

extension CategoryDataSource: FeedVCDelegate {
    
    func updateDataInVC(_ vc: FeedVC) {
        searchActive = vc.searchActive
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.categoriesViewModelArray.filter({ (category) -> Bool in
            let categoryNameToFind = category.categoryListTitle.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            //let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            //let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return (categoryNameToFind != nil) //|| (typeToFind != nil) || (locationToFind != nil)
        })
    }
}



