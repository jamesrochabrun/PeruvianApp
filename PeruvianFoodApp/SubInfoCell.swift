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
    
    //MARK: UI Elements
    let addressLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: nil, sizeToFit: true).build()
    let categoryLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: nil, sizeToFit: true).build()
    let phoneLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: nil, sizeToFit: true).build()
    
    let phoneImageViewIcon = ImageViewBuilder.imageWithRenderMode(image: #imageLiteral(resourceName: "phone"), radius: nil, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false, tintColor: .white).build()
    let categoryViewIcon = ImageViewBuilder.imageWithRenderMode(image: #imageLiteral(resourceName: "category"), radius: nil, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false, tintColor: .white).build()

    let addressViewIcon = ImageViewBuilder.imageWithRenderMode(image: #imageLiteral(resourceName: "location"), radius: nil, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false, tintColor: .white).build()
    
    //MARK: Set up UI
    override func setUpViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(addressLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(addressViewIcon)
        contentView.addSubview(phoneImageViewIcon)
        contentView.addSubview(categoryViewIcon)

        phoneLabel.isUserInteractionEnabled = true
        phoneLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performCall)))
        
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
    
    //MARK: call handler
    @objc private func performCall() {
        
        guard let numberText = phoneLabel.text else { return }
        guard let number = URL(string: "telprompt://" + numberText) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }

    //MARK: Helper method to setup Cell
    func setUp(with businessViewModel: BusinessViewModel) {
        
        addressLabel.text = businessViewModel.address
        categoryLabel.text = businessViewModel.category
        phoneLabel.text = businessViewModel.phone
    }
}









