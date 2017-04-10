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
    
    convenience init(categoryViewModel: CategoryViewModel) {
        
        self.init()
        if let items = categoryViewModel.items {
            self.itemViewModelArray = items.map{ItemViewModel(categoryItem: $0)}
        }
    }
    
    var itemViewModelArray = [ItemViewModel]()
    var searchResults = [ItemViewModel]()
    var searchActive : Bool = false
    var categoryItemsFeedVC: CategoryItemsFeedVC? {
        didSet {
            self.categoryItemsFeedVC?.delegate = self
        }
    }
    var selection = Selection()
    
    func getitemViewModelArray() -> [ItemViewModel] {
        return itemViewModelArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SwitchCell
        let itemViewModel = searchActive ? searchResults[indexPath.row] : itemViewModelArray[indexPath.row]
        cell.setUpCell(with: itemViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? searchResults.count : itemViewModelArray.count
    }
}

extension CategoryItemsFeedDataSource: SwitchCellDelegate {
    
    func switchCell(_ cell: SwitchCell) {
        
        self.categoryItemsFeedVC?.selection = self.selection        

        if let indexPath = categoryItemsFeedVC?.tableView.indexPath(for: cell) {
            itemViewModelArray[indexPath.row].isSelected = cell.customSwitch.isOn
            
            let itemViewModelTitle = itemViewModelArray[indexPath.row].itemTitle
            if cell.customSwitch.isOn {
                selection.categoryItems?.append(itemViewModelTitle)
            } else {
                selection.categoryItems?.removeLast()
            }
        }
    }
}

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

struct ItemViewModel {
    
    var itemTitle: String
    var isSelected: Bool
    
    init(categoryItem: CategoryItem) {
        self.itemTitle = categoryItem.title
        self.isSelected = false
    }
}


struct Selection {
    
    init() {
    }
    
    var term: String?
    var categoryItems: [String]?
}











