//
//  HeaderCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class HeaderCell: BaseCell {
    
    let businessImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .center
        iv.clipsToBounds = true
        return iv
    }()
    
    let businessNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    let overlayView: UIView = {
        let v = UIView()
        v.blur(with : .light)
        v.opaque(with: Constants.Colors.darkTextColor, alpha: 0.05)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .center
        iv.clipsToBounds = true
        return iv
    }()
    
    let dismissButton: CustomDismissButton = {
        let dbv = CustomDismissButton()
        return dbv
    }()
    
    override func setUpViews() {
        
        addSubview(businessImageView)
        addSubview(dismissButton)
        addSubview(overlayView)
        addSubview(businessNameLabel)
        businessNameLabel.sizeToFit()
        addSubview(ratingImageView)
        
        NSLayoutConstraint.activate([
            
            businessImageView.widthAnchor.constraint(equalTo: widthAnchor),
            businessImageView.heightAnchor.constraint(equalTo: heightAnchor),
            businessImageView.leftAnchor.constraint(equalTo: leftAnchor),
            businessImageView.topAnchor.constraint(equalTo: topAnchor),
            
            dismissButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            dismissButton.topAnchor.constraint(equalTo: topAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: Constants.UI.dismissButtonHeight),
            dismissButton.widthAnchor.constraint(equalToConstant: Constants.UI.dismissButtonWidth),
            
            overlayView.leftAnchor.constraint(equalTo: leftAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: 100),
            overlayView.centerYAnchor.constraint(equalTo: centerYAnchor),
            overlayView.widthAnchor.constraint(equalTo: widthAnchor),
            
            businessNameLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            businessNameLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            businessNameLabel.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.7),
            
            ratingImageView.heightAnchor.constraint(equalToConstant: 30),
            ratingImageView.widthAnchor.constraint(equalToConstant: 150),
            ratingImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            ratingImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
            ])
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        businessImageView.loadImageUsingCacheWithURLString(businessViewModel.profileImageURL, placeHolder: nil) { (complete) in
        }
        businessNameLabel.text = businessViewModel.name
        let reviewIcon = ReviewIcon(reviewNumber: businessViewModel.rating)
        ratingImageView.image = reviewIcon.image
    }
}
