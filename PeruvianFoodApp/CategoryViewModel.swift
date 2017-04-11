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
    var categoryListTitle: String = ""
    
    //Get one specific category and convert it in a viewmodel that contains ...
    //Category title
    //items inside the category
    func getCategoryAsViewModel(for categoryTitle:CategoryTitles, completion: @escaping (CategoryViewModel) -> Void)  {
        
        let categoryService = CategoryService()
        categoryService.get { (result) in
            switch result {
            case .Success(let categoryItemsArray):
                var resultsArray = [CategoryItem]()
                for categoryItem in categoryItemsArray {
                    if let resultCategory = categoryItem,
                        let parentArray = resultCategory.parentsArray {
                        if  parentArray.contains(categoryTitle.rawValue) {
                            resultsArray.append(resultCategory)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(CategoryViewModel(items: resultsArray, categoryListTitle: categoryTitle.rawValue))
                }
            case .Error(let error):
                print(error)
            }
        }
    }
    
    //Get all the categories as ViewModel
    func getAllCategoriesAsViewModel(completion: @escaping (_ categoryListViewModelArray: Array<CategoryViewModel>) -> ()) {
        
        var categoriyViewModelArray = Array<CategoryViewModel>()
        for category in CategoryTitles.categoryTitlesArray {
            
            self.getCategoryAsViewModel(for: category, completion: { (categoryViewModel) in
                categoriyViewModelArray.append(categoryViewModel)
                if categoriyViewModelArray.count == CategoryTitles.categoryTitlesArray.count {
                    DispatchQueue.main.async {
                        completion(categoriyViewModelArray)
                    }
                }
            })
        }
    }
}


enum CategoryTitles: String {
    
    case restaurants
    case localservices
    case italian
    case bars
    case food
    case fashion
    case professional
    case beautysvc
    case health
    case physicians
    case shopping
    case education
    case nightlife
    case fitness
    case tours
    case religiousorgs
    case hotels
    case auto
    case transport
    case hotelstravel
    case airports
    case active
    case portuguese
    case french
    case petservices
    case pets
    case realestate
    case homeandgarden
    case arabian
    case arts
    case spanish
    case homeservices
    case museums
    case specialtyschools
    case artsandcrafts
    case farms
    case insurance
    case plumbing
    case german
    case lawyers
    case eventservices
    case financialservices
    case localflavor
    case massmedia
    case publicservicesgovt
    
    static var categoryTitlesArray: [CategoryTitles]  {
        return [.restaurants, .localservices, .italian, .bars, .food, .fashion, .professional, .beautysvc, .health, .physicians, .shopping, .education,
                .nightlife, .fitness, .tours, .religiousorgs, .hotels, .auto, .transport, .hotelstravel, .airports, .active, .portuguese, .french, .petservices, .pets,
                .realestate, .homeandgarden, .arabian, .arts, .spanish, .homeservices, .museums, .specialtyschools, .artsandcrafts, .farms, .insurance, .plumbing, .german,
                .lawyers, .eventservices, .financialservices, .localflavor, .massmedia, .publicservicesgovt]
    }
    
}
