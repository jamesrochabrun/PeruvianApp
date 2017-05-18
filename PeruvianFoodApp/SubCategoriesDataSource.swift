//
//  CategoryItemsFeedDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class SubCategoriesDataSource: NSObject, UITableViewDataSource {
    
    //MARK: Properties
    fileprivate var itemsViewModelArray = [SubCategoryViewModel]()
    fileprivate var searchResults = [SubCategoryViewModel]()
    fileprivate var searchActive : Bool = false
    
    //MARK: binding the delegate on creation this delegate is in charge of the searchbar logic from SearchVC
    weak var subCategoriesVC: SubCategoriesVC? {
        didSet {
            self.subCategoriesVC?.delegate = self
        }
    }
    fileprivate var selection = Selection()
    
    //MARK: Initializer and data updater
    override init() {
        super.init()
    }
    
    func updateWith(_ mainCategoryViewModel: MainCategoryViewModel) {
        
        self.selection.mainCategory = mainCategoryViewModel.mainCategory
        if let subCategories = mainCategoryViewModel.subCategories {
            self.itemsViewModelArray = subCategories.map { SubCategoryViewModel(subCategory: $0) }
        }
    }
    
    //MARK: Tableview Datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SwitchCell
        let categoryItemViewModel = getSubCategoryViewModelFrom(indexPath)
        cell.setUpCell(with: categoryItemViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? searchResults.count : itemsViewModelArray.count
    }
}

//MARK: Helper methods
extension SubCategoriesDataSource {
    
    func getSubCategoryViewModelFrom(_ indexPath: IndexPath) -> SubCategoryViewModel {
        
        return searchActive ? searchResults[indexPath.row] : itemsViewModelArray[indexPath.row]
    }
    
    func getSelection() -> Selection {
        return selection
    }
}

//MARK: SearchVC delegation
extension SubCategoriesDataSource: SearchVCDelegate {
    
    func updateDataInVC(_ vc: SearchVC) {
        searchActive = vc.searchActive
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.itemsViewModelArray.filter({ (item) -> Bool in
            let itemNameToFind = item.itemTitle.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            return (itemNameToFind != nil)
        })
    }
}

//MARK Switchcelldelegate
extension SubCategoriesDataSource: SwitchCellDelegate {
    
    func switchCell(_ cell: SwitchCell) {
        
        if let indexPath = subCategoriesVC?.tableView.indexPath(for: cell) {
            itemsViewModelArray[indexPath.row].isSelected = cell.customSwitch.isOn
            
            let itemViewModelAlias = itemsViewModelArray[indexPath.row].itemAlias
            if cell.customSwitch.isOn {
                selection.categoryItems.append(itemViewModelAlias)
            } else {
                selection.categoryItems.removeLast()
            }
        }
    }
}











