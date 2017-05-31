//
//  ReusableHeaderCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/30/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class ReusableHeaderCell: BaseCell {
    
    //MARK: UI elements
    let headerTextLabel = LabelBuilder.headerLabel(textColor: .darkTextColor, textAlignment: .left, sizeToFit: true).build()
    var businessImageView = ImageViewBuilder.imageView(radius: 10.0, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
    
    override func setUpViews() {
        
        addSubview(headerTextLabel)
        addSubview(businessImageView)
        businessImageView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            
            businessImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            businessImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            businessImageView.widthAnchor.constraint(equalToConstant: Constants.UI.reusableHeaderCellHeight / 2),
            businessImageView.heightAnchor.constraint(equalToConstant: Constants.UI.reusableHeaderCellHeight / 2),
            
            headerTextLabel.leftAnchor.constraint(equalTo: businessImageView.rightAnchor, constant: 15),
            headerTextLabel.centerYAnchor.constraint(equalTo: businessImageView.centerYAnchor),
            ])
    }
    
    //MARK: set up Cell
    func setUpWith(text: String) {
        headerTextLabel.text = text
    }
}
