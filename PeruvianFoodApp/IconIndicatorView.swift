//
//  IconIndicatorView.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class IconIndicatorView: BaseView {
    
    let indicatorImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let indicatorLabel = LabelBuilder.caption1(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    
    override func setUpViews() {
        
        addSubview(indicatorImageView)
        addSubview(indicatorLabel)
        
        NSLayoutConstraint.activate([
            
            indicatorImageView.topAnchor.constraint(equalTo: topAnchor),
            indicatorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            indicatorImageView.widthAnchor.constraint(equalTo: indicatorImageView.heightAnchor),
            
            indicatorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            indicatorLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
}


