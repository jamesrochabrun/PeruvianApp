//
//  CategoryViewModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

struct CategoryViewModel {
    
    var items: [CategoryItem]?
    var mainCategory = MainCategory()
    
    //Get one specific Main Category and convert it in a CategoryViewModel that contains ...
    //Main Category title
    //subCategories inside the Main Category
    func getMainCategoryAsViewModel(for mainCategory: MainCategory, completion: @escaping (CategoryViewModel) -> ())  {
        
        let categoryService = CategoryService()
        categoryService.get { (result) in
            switch result {
            case .Success(let categoryItemsArray):
                var resultsArray = [CategoryItem]()
                for categoryItem in categoryItemsArray {
                    if let resultCategory = categoryItem,
                        let parentArray = resultCategory.parentsArray {
                        if  parentArray.contains(mainCategory.rawValue) {
                            resultsArray.append(resultCategory)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(CategoryViewModel(items: resultsArray, mainCategory: mainCategory))
                }
            case .Error(let error):
                print(error)
            }
        }
    }
    
    //Get all the subCategories as CategoryViewModel
    func getAllCategoriesAsViewModel(completion: @escaping (_ categoryListViewModelArray: Array<CategoryViewModel>) -> ()) {
        
        var categoryViewModelArray = Array<CategoryViewModel>()
        for category in MainCategory.categories {
            self.getMainCategoryAsViewModel(for: category, completion: { (categoryViewModel) in
                categoryViewModelArray.append(categoryViewModel)
                if categoryViewModelArray.count == MainCategory.categories.count {
                    DispatchQueue.main.async {
                        completion(categoryViewModelArray)
                    }
                }
            })
        }
    }
}












