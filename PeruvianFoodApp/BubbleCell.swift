//
//  BubbleCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/16/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class BubbleCell: BaseCollectionViewCell {
    
    let categoryImageview: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 45
        iv.clipsToBounds = true
        iv.backgroundColor = .purple
        return iv
    }()
    
    let categoryLabel = LabelBuilder.headerLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    override func setupViews() {
        
        addSubview(categoryImageview)
        addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            
            categoryImageview.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryImageview.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryImageview.widthAnchor.constraint(equalToConstant: 90),
            categoryImageview.heightAnchor.constraint(equalToConstant: 90),
            
            categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    func setUpCell(_ category: MainCategory) {
        categoryLabel.text = category.rawValue
    }
}






