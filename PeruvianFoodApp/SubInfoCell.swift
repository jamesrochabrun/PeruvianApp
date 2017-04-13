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
    
    let phoneLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textAlignment = .left
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return l
    }()
    
    let phoneImageViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "phone").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        return iv
    }()
    let categoryViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "category").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        return iv
    }()
    let addressViewIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "location").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
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
        
        addressLabel.sizeToFit()
        phoneLabel.sizeToFit()
        categoryLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            
            addressViewIcon.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 10),
            addressViewIcon.heightAnchor.constraint(equalToConstant: 25),
            addressViewIcon.widthAnchor.constraint(equalToConstant: 25),
            addressViewIcon.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5),
            
            addressLabel.leftAnchor.constraint(equalTo: addressViewIcon.rightAnchor, constant: 5),
            addressLabel.centerYAnchor.constraint(equalTo: addressViewIcon.centerYAnchor),
            addressLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: -10),
            
            phoneImageViewIcon.leftAnchor.constraint(equalTo: addressViewIcon.leftAnchor),
            phoneImageViewIcon.heightAnchor.constraint(equalTo: addressViewIcon.heightAnchor),
            phoneImageViewIcon.widthAnchor.constraint(equalTo: addressViewIcon.widthAnchor),
            phoneImageViewIcon.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            
            phoneLabel.centerYAnchor.constraint(equalTo: phoneImageViewIcon.centerYAnchor),
            phoneLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor),
            phoneLabel.rightAnchor.constraint(equalTo: addressLabel.rightAnchor),
            
            categoryViewIcon.leftAnchor.constraint(equalTo: addressViewIcon.leftAnchor),
            categoryViewIcon.heightAnchor.constraint(equalTo: addressViewIcon.heightAnchor),
            categoryViewIcon.widthAnchor.constraint(equalTo: addressViewIcon.widthAnchor),
            categoryViewIcon.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            
            categoryLabel.centerYAnchor.constraint(equalTo: categoryViewIcon.centerYAnchor),
            categoryLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor),
            categoryLabel.rightAnchor.constraint(equalTo: addressLabel.rightAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -10)
            ])
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        
        addressLabel.text = businessViewModel.address
        categoryLabel.text = businessViewModel.category
        phoneLabel.text = businessViewModel.phone
    }
}



