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
    fileprivate var categoriesViewModelArray: [MainCategoryViewModel]

    //MARK: Initializer
    init(categoriesViewModelArray: [MainCategoryViewModel]) {
        self.categoriesViewModelArray = categoriesViewModelArray
        super.init()
    }
    
    //MARK: Tableview Datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCell
        let mainCategoryViewModel = getMainCategoryViewModelFrom(indexPath)
        cell.setUpCell(with: mainCategoryViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesViewModelArray.count
    }
}

//MARK: Helper methods
extension MainCategoriesDataSource {
    
    func getMainCategoryViewModelFrom(_ indexPath: IndexPath) -> MainCategoryViewModel {
        return categoriesViewModelArray[indexPath.row]
    }
    
    func update(with viewModels: [MainCategoryViewModel]) {
        self.categoriesViewModelArray = viewModels
    }
}





