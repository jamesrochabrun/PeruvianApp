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
    var categoryItemsFeedVC: CategoryItemsFeedVC?
    
    func getitemViewModelArray() -> [ItemViewModel] {
        return itemViewModelArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SwitchCell
        let itemViewModel = itemViewModelArray[indexPath.row]
        cell.setUpCell(with: itemViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemViewModelArray.count
    }
}

extension CategoryItemsFeedDataSource: SwitchCellDelegate {
    
    func switchCell(_ cell: SwitchCell) {
        
        if let indexPath = categoryItemsFeedVC?.tableView.indexPath(for: cell) {
            itemViewModelArray[indexPath.row].isSelected = cell.customSwitch.isOn
        }
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






