//
//  ListCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/7/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell: BaseCell {
    
    //MARK: UI Elements
    let listNameLabel = LabelBuilder.headerLabel(textColor: .darkTextColor , textAlignment: nil, sizeToFit: true).build()

    //MARK: setUp UI
    override func setUpViews() {
        
        addSubview(listNameLabel)
        NSLayoutConstraint.activate([
            listNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            listNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.swicthCellPadding),
        ])
    }
    
    //MARK: Helper method to set up data in cell
    func setUpCell(with mainCategoryViewModel: MainCategoryViewModel) {
        listNameLabel.text = mainCategoryViewModel.mainCategory.rawValue
    }
}
