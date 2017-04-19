//
//  BusinesCell.swift
//  YelpClient
//
//  Created by James Rochabrun on 4/4/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreImage

class BusinesCell: BaseCell {

    var businessImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.opaque(with: Constants.Colors.darkTextColor, alpha: 0.4)
        return iv
    }()
    
    let ratingView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let businessNameLabel = LabelBuilder.headerLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    let distanceLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: .right, sizeToFit: true).build()
    let reviewsLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: nil, sizeToFit: true).build()
    let priceLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: .right, sizeToFit: true).build()
    let addressLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    let categoryLabel = LabelBuilder.caption1(textColor: .white, textAlignment: .center, sizeToFit: true).build()

    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.white)
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
        addSubview(dividerLine)
        
        //layout1(marginGuide)
        
        NSLayoutConstraint.activate([
            
            businessImageView.widthAnchor.constraint(equalTo: widthAnchor),
            businessImageView.heightAnchor.constraint(equalTo: heightAnchor),
            businessImageView.leftAnchor.constraint(equalTo: leftAnchor),
            businessImageView.topAnchor.constraint(equalTo: topAnchor),
            
            distanceLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            distanceLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 8),
            priceLabel.rightAnchor.constraint(equalTo: distanceLabel.rightAnchor),
            priceLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
            
            businessNameLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 8),
            businessNameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            businessNameLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: -8),
            
            addressLabel.leftAnchor.constraint(equalTo: businessNameLabel.leftAnchor),
            addressLabel.topAnchor.constraint(equalTo: businessNameLabel.bottomAnchor, constant: 8),
            addressLabel.rightAnchor.constraint(equalTo: businessNameLabel.rightAnchor),
            
            categoryLabel.leftAnchor.constraint(equalTo: businessNameLabel.leftAnchor),
            categoryLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            categoryLabel.rightAnchor.constraint(equalTo: businessNameLabel.rightAnchor),
            
            ratingView.heightAnchor.constraint(equalToConstant: 20),
            ratingView.widthAnchor.constraint(equalToConstant: 100),
            ratingView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            ratingView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            ratingView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -8),
            
            reviewsLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            reviewsLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 8),
            
            dividerLine.heightAnchor.constraint(equalToConstant: 0.3),
            dividerLine.widthAnchor.constraint(equalTo: widthAnchor),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    
    func layout1(_ marginGuide: UILayoutGuide) {
        
        //less than 251 contenthugging
        businessNameLabel.setContentHuggingPriority(250, for: .horizontal)
        //greater than 751 compression
        distanceLabel.setContentCompressionResistancePriority(751, for: .horizontal)
        
        NSLayoutConstraint.activate([
            
            businessImageView.heightAnchor.constraint(equalToConstant: 64),
            businessImageView.widthAnchor.constraint(equalToConstant: 64),
            businessImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 8),
            businessImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            
            businessNameLabel.leftAnchor.constraint(equalTo: businessImageView.rightAnchor, constant: 8),
            businessNameLabel.topAnchor.constraint(equalTo: businessImageView.topAnchor),
            businessNameLabel.rightAnchor.constraint(lessThanOrEqualTo: distanceLabel.leftAnchor, constant: -8),
            
            distanceLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            distanceLabel.topAnchor.constraint(equalTo: businessNameLabel.topAnchor),
            
            ratingView.heightAnchor.constraint(equalToConstant: 30),
            ratingView.widthAnchor.constraint(equalToConstant: 90),
            ratingView.leftAnchor.constraint(equalTo: businessNameLabel.leftAnchor),
            ratingView.topAnchor.constraint(equalTo: businessNameLabel.bottomAnchor, constant: 8),
            
            reviewsLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            reviewsLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 8),
            
            priceLabel.rightAnchor.constraint(equalTo: distanceLabel.rightAnchor),
            priceLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
            
            addressLabel.leftAnchor.constraint(equalTo: businessNameLabel.leftAnchor),
            addressLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8),
            addressLabel.rightAnchor.constraint(equalTo: distanceLabel.rightAnchor),
            
            categoryLabel.leftAnchor.constraint(equalTo: businessNameLabel.leftAnchor),
            categoryLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            categoryLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
            
            dividerLine.heightAnchor.constraint(equalToConstant: 0.5),
            dividerLine.widthAnchor.constraint(equalTo: widthAnchor),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            ])
    }
    
    override func prepareForReuse() {
        businessImageView.image = nil
    }
    
    func setUpCell(with viewModel: BusinessViewModel) {
        
        businessNameLabel.text = viewModel.name
        distanceLabel.text = viewModel.distance
        reviewsLabel.text = viewModel.reviewsCount
        addressLabel.text = viewModel.address
        categoryLabel.text = viewModel.category
        priceLabel.text = viewModel.price
        ratingView.image = viewModel.ratingImage
        guard let url = URL(string: viewModel.profileImageURL) else {
            print("INVALID URL ON CREATION BASECELL")
            return
        }
        businessImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: true) { (response) in
            guard let image = response.result.value else {
                print("INVALID RESPONSE SETTING UP THE BASECELL")
                return
            }
            self.businessImageView.image = image
        }
    }
}












