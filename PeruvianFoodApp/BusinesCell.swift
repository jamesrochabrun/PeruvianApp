//
//  BusinesCell.swift
//  YelpClient
//
//  Created by James Rochabrun on 4/4/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class BusinesCell: BaseCell {
    
    let businessImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    let ratingView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 2
        iv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        iv.clipsToBounds = true
        return iv
    }()
    
    let businessNameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.darkTextColor)
        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        //l.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return l
    }()
    
    let distanceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        // l.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        l.textAlignment = .left
        return l
    }()
    
    let reviewsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        // l.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return l
    }()
    
    let priceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        //l.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        return l
    }()
    
    let addressLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        //l.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return l
    }()
    
    let categoryLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        // l.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return l
    }()
    
    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //businessNameLabel.preferredMaxLayoutWidth = businessNameLabel.frame.size.width
    }
    
    override func setUpViews() {
        
        // print(businessNameLabel.frame.size.width)
        // businessNameLabel.preferredMaxLayoutWidth = businessNameLabel.frame.size.width
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(businessImageView)
        contentView.addSubview(ratingView)
        contentView.addSubview(businessNameLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(reviewsLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(categoryLabel)
        
        businessImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        businessImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        businessImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 8).isActive = true
        businessImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor).isActive = true
        
        businessNameLabel.sizeToFit()
        businessNameLabel.leftAnchor.constraint(equalTo: businessImageView.rightAnchor, constant: 8).isActive = true
        businessNameLabel.topAnchor.constraint(equalTo: businessImageView.topAnchor).isActive = true
        businessNameLabel.rightAnchor.constraint(lessThanOrEqualTo: distanceLabel.leftAnchor, constant: -8).isActive = true
        businessNameLabel.setContentHuggingPriority(250, for: .horizontal)
        
        //less than 251 contenthugging
        
        distanceLabel.sizeToFit()
        distanceLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: businessNameLabel.topAnchor).isActive = true
        distanceLabel.setContentCompressionResistancePriority(751, for: .horizontal)
        
        //greater than 751 compression
        ratingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        ratingView.leftAnchor.constraint(equalTo: businessNameLabel.leftAnchor).isActive = true
        ratingView.topAnchor.constraint(equalTo: businessNameLabel.bottomAnchor, constant: 8).isActive = true
        
        reviewsLabel.sizeToFit()
        reviewsLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        reviewsLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 8).isActive = true
        
        priceLabel.sizeToFit()
        priceLabel.rightAnchor.constraint(equalTo: distanceLabel.rightAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8).isActive = true
        
        addressLabel.sizeToFit()
        addressLabel.leftAnchor.constraint(equalTo: businessNameLabel.leftAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: distanceLabel.rightAnchor).isActive = true
        
        categoryLabel.sizeToFit()
        categoryLabel.leftAnchor.constraint(equalTo: businessNameLabel.leftAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        addSubview(dividerLine)
        dividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        dividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

