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
    
    var business: Business? {
        didSet {
            if let business = business {
                let businessViewModel = BusinessViewModel(model: business, at: nil)
                self.setUp(with: businessViewModel)
            }
        }
    }
    
    let addressLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: nil, sizeToFit: true).build()
    let categoryLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: nil, sizeToFit: true).build()
    let phoneLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: nil, sizeToFit: true).build()
    
    let phoneImageViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "phone").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        return iv
    }()
    let categoryViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "category").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        return iv
    }()
    let addressViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "location").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    override func setUpViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(addressLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(addressViewIcon)
        contentView.addSubview(phoneImageViewIcon)
        contentView.addSubview(categoryViewIcon)

        NSLayoutConstraint.activate([
            
            addressViewIcon.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 15),
            addressViewIcon.heightAnchor.constraint(equalToConstant: 25),
            addressViewIcon.widthAnchor.constraint(equalToConstant: 25),
            addressViewIcon.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5),
            
            addressLabel.leftAnchor.constraint(equalTo: addressViewIcon.rightAnchor, constant: 8),
            addressLabel.centerYAnchor.constraint(equalTo: addressViewIcon.centerYAnchor),
            addressLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: -10),
            
            phoneImageViewIcon.leftAnchor.constraint(equalTo: addressViewIcon.leftAnchor),
            phoneImageViewIcon.heightAnchor.constraint(equalTo: addressViewIcon.heightAnchor),
            phoneImageViewIcon.widthAnchor.constraint(equalTo: addressViewIcon.widthAnchor),
            phoneImageViewIcon.topAnchor.constraint(equalTo: addressViewIcon.bottomAnchor, constant: 8),
            
            phoneLabel.centerYAnchor.constraint(equalTo: phoneImageViewIcon.centerYAnchor),
            phoneLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor),
            phoneLabel.rightAnchor.constraint(equalTo: addressLabel.rightAnchor),
            
            categoryViewIcon.leftAnchor.constraint(equalTo: addressViewIcon.leftAnchor),
            categoryViewIcon.heightAnchor.constraint(equalTo: addressViewIcon.heightAnchor),
            categoryViewIcon.widthAnchor.constraint(equalTo: addressViewIcon.widthAnchor),
            categoryViewIcon.topAnchor.constraint(equalTo: phoneImageViewIcon.bottomAnchor, constant: 8),
            
            categoryLabel.centerYAnchor.constraint(equalTo: categoryViewIcon.centerYAnchor),
            categoryLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor),
            categoryLabel.rightAnchor.constraint(equalTo: addressLabel.rightAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -10)
            ])
    }
    
    private func setUp(with businessViewModel: BusinessViewModel) {
        
        addressLabel.text = businessViewModel.address
        categoryLabel.text = businessViewModel.category
        phoneLabel.text = businessViewModel.phone
    }
}



