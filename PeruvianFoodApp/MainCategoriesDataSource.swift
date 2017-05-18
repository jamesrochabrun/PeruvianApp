//
//  CategoryDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


class MainCategoriesDataSource: NSObject, UITableViewDataSource {
    
    //Mark: properties
    fileprivate var categoriesViewModelArray = [MainCategoryViewModel]()
    fileprivate var searchResults = [MainCategoryViewModel]()
    fileprivate var searchActive : Bool = false
    
    //MARK: binding the delegate on creation this delegate is in charge of the searchbar logic from SearchVC
    weak var mainCategoriesVC: MainCategoriesVC? {
        didSet {
            self.mainCategoriesVC?.delegate = self
        }
    }
    
    //MARK: Initializer
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        
        let mainCategoryViewModel = MainCategoryViewModel()
        mainCategoryViewModel.getMainCategories { [unowned self] (mainCategoriesArray) in
            self.categoriesViewModelArray = mainCategoriesArray
        }
    }
    
    //MARK: Tableview Datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCell
        let mainCategoryViewModel = getMainCategoryViewModelFrom(indexPath)
        cell.setUpCell(with: mainCategoryViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? searchResults.count : categoriesViewModelArray.count
    }
}

//MARK: Helper methods
extension MainCategoriesDataSource {
    
    func getMainCategoryViewModelFrom(_ indexPath: IndexPath) -> MainCategoryViewModel {
        
        return searchActive ? searchResults[indexPath.row] : categoriesViewModelArray[indexPath.row]
    }
}

//MARK: SearchVC delegation
extension MainCategoriesDataSource: SearchVCDelegate {
    
    func updateDataInVC(_ vc: SearchVC) {
        searchActive = vc.searchActive
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.categoriesViewModelArray.filter({ (category) -> Bool in
            let categoryNameToFind = category.mainCategory.rawValue.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            return (categoryNameToFind != nil)
        })
    }
}








