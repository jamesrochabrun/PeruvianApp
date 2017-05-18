//
//  CategoryViewModel.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

struct MainCategoryViewModel {
    
    var subCategories: [SubCategory]?
    var mainCategory = MainCategory()
    
    //Get one specific Main Category and convert it in a CategoryViewModel that contains ...
    //Main Category title
    //subCategories inside the Main Category
    func getCategories(for mainCategory: MainCategory, completion: @escaping (MainCategoryViewModel) -> ())  {
        
        let categoryService = CategoryService()
        categoryService.get { (result) in
            switch result {
            case .Success(let categoryItemsArray):
                var resultsArray = [SubCategory]()
                for categoryItem in categoryItemsArray {
                    if let resultCategory = categoryItem,
                        let parentArray = resultCategory.parentsArray {
                        if  parentArray.contains(mainCategory.rawValue) {
                            resultsArray.append(resultCategory)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(MainCategoryViewModel(subCategories: resultsArray, mainCategory: mainCategory))
                }
            case .Error(let error):
                print(error)
            }
        }
    }
    
    //Get all the subCategories as CategoryViewModel
    func getMainCategories(completion: @escaping (_ categoryListViewModelArray: Array<MainCategoryViewModel>) -> ()) {
        
        var categoryViewModelArray = Array<MainCategoryViewModel>()
        for category in MainCategory.categories {
            self.getCategories(for: category, completion: { (categoryViewModel) in
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












