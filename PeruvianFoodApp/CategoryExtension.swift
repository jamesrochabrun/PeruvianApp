//
//  CategoryExtension.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/7/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

extension Category {
    
    init?(dict: [String : AnyObject]) {
        
        guard let alias = dict[Key.categoryAliasKey] as? String,
            let title = dict[Key.categoryTitleKey] as? String,
            let parentsArray = dict[Key.categoryParentsKey] as? [String] else {
                return nil
        }
        self.alias = alias
        self.title = title
        self.parentsArray = parentsArray
    }
    
    static func getCategories(for categoryTitle:CategoryTitles, completion: @escaping ([Category]) -> Void)  {
        
        let categoryService = CategoryService()
        categoryService.get { (result) in
            switch result {
            case .Success(let categoryArray):
                var resultsArray = [Category]()
                for category in categoryArray {
                    if let resultCategory = category,
                        let parentArray = resultCategory.parentsArray {
                        if  parentArray.contains(categoryTitle.rawValue) {
                            resultsArray.append(resultCategory)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(resultsArray)
                }
            case .Error(let error):
                print(error)
            }
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
}







