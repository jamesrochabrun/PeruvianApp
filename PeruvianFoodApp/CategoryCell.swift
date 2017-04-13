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
    
    let listNameLabel = LabelBuilder.headerLabel(textColor: .darkTextColor , textAlignment: nil, sizeToFit: true).build()

    override func setUpViews() {
        
        addSubview(listNameLabel)
        
        NSLayoutConstraint.activate([
            listNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            listNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.swicthCellPadding),
        ])
    }
}
