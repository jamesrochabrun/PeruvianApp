//
//  CategoryItemsFeedDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CategoryItemsFeedDataSource: NSObject, UITableViewDataSource {
    
    override init() {
        super.init()
    }
    //MARK: creating datasource from a Categoryview model that contains a title and an array of items
    convenience init(categoryViewModel: CategoryViewModel) {
        
        self.init()
        selection.categoryParent = categoryViewModel.categoryListTitle
        if let items = categoryViewModel.items {
            self.itemViewModelArray = items.map{CategoryItemViewModel(categoryItem: $0)}
        }
    }
    
    fileprivate var itemViewModelArray = [CategoryItemViewModel]()
    fileprivate var searchResults = [CategoryItemViewModel]()
    fileprivate var searchActive : Bool = false
    //binding the delegate on creation
    weak var categoryItemsFeedVC: CategoryItemsFeedVC? {
        didSet {
            self.categoryItemsFeedVC?.delegate = self
        }
    }
    fileprivate var selection = Selection()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SwitchCell
        let categoryItemViewModel = getItemViewModelFromIndexpath(indexPath)
        cell.setUpCell(with: categoryItemViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? searchResults.count : itemViewModelArray.count
    }
}

//MARK: Helper methods
extension CategoryItemsFeedDataSource {
    
    func getItemViewModelFromIndexpath(_ indexPath: IndexPath) -> CategoryItemViewModel {
        
        return searchActive ? searchResults[indexPath.row] : itemViewModelArray[indexPath.row]
    }
    
    func getSelection() -> Selection {
        return selection
    }
}

//MARK Switchcelldelegate
extension CategoryItemsFeedDataSource: SwitchCellDelegate {
    
    func switchCell(_ cell: SwitchCell) {
        
        if let indexPath = categoryItemsFeedVC?.tableView.indexPath(for: cell) {
            itemViewModelArray[indexPath.row].isSelected = cell.customSwitch.isOn
            
            let itemViewModelAlias = itemViewModelArray[indexPath.row].itemAlias
            if cell.customSwitch.isOn {
                selection.categoryItems.append(itemViewModelAlias)
                print(selection.categoryItems.count)
            } else {
                selection.categoryItems.removeLast()
                print("remo", selection.categoryItems.count)
            }
        }
    }
}

//MARK: MAIN class FeedVC delegate method
extension CategoryItemsFeedDataSource: FeedVCDelegate {
    
    func updateDataInVC(_ vc: FeedVC) {
        searchActive = vc.searchActive
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.itemViewModelArray.filter({ (item) -> Bool in
            let itemNameToFind = item.itemTitle.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            //let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            //let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return (itemNameToFind != nil) //|| (typeToFind != nil) || (locationToFind != nil)
        })
    }
}









