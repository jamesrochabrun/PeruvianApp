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
    
    let listNameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.darkTextColor)
//        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        return l
    }()
    
    override func setUpViews() {
        
        addSubview(listNameLabel)
        listNameLabel.sizeToFit()
        listNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        listNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.swicthCellPadding).isActive = true
    }
}
