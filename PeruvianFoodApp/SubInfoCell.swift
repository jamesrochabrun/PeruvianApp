//
//  SubInfoCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class SubInfoCell: BaseCell {
    
    let addressLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textAlignment = .left
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return l
    }()
    
    let categoryLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textAlignment = .left
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return l
    }()
    
    override func setUpViews() {
        
        backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(addressLabel)
        contentView.addSubview(categoryLabel)
        
        addressLabel.sizeToFit()
        categoryLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            
            addressLabel.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor),
            addressLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10),
            addressLabel.widthAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: 0.8),
            
            categoryLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15),
            categoryLabel.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor),
            categoryLabel.widthAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: 0.8),
            categoryLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -10)
            ])
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        
        addressLabel.text = businessViewModel.address
        categoryLabel.text = businessViewModel.category
    }
}



