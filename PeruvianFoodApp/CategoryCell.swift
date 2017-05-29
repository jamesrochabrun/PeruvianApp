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
    let listNameLabel = LabelBuilder.headerLabel(textColor: .white , textAlignment: .center, sizeToFit: true).build()
    let categoryImageView = ImageViewBuilder.imageView(radius: nil, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Colors.white.color
        return v
    }()

    //MARK: setUp UI
    override func setUpViews() {
        
        categoryImageView.opaque(with: Constants.Colors.darkTextColor, alpha: 0.4)
        listNameLabel.font = UIFont(name: Constants.Font.regularFont, size: 30)
        addSubview(categoryImageView)
        addSubview(listNameLabel)
        addSubview(dividerLine)
        
        NSLayoutConstraint.activate([
            
            categoryImageView.topAnchor.constraint(equalTo: topAnchor),
            categoryImageView.leftAnchor.constraint(equalTo: leftAnchor),
            categoryImageView.rightAnchor.constraint(equalTo: rightAnchor),
            categoryImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            listNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            listNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            dividerLine.heightAnchor.constraint(equalToConstant: 0.3),
            dividerLine.widthAnchor.constraint(equalTo: widthAnchor),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //MARK: Helper method to set up data in cell
    func setUpCell(with mainCategoryViewModel: MainCategoryViewModel) {
        listNameLabel.text = mainCategoryViewModel.mainCategory.rawValue
        categoryImageView.image = UIImage(named: mainCategoryViewModel.mainCategory.rawValue)
    }
}
