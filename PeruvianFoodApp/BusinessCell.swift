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
import AlamofireImage

final class BusinessCell: BaseCell {

    //MARK: UI Elements
    var businessImageView: UIImageView = {
        let iv = ImageViewBuilder.imageView(radius: nil, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
        iv.opaque(with: Constants.Colors.darkTextColor, alpha: 0.4)
        return iv
    }()
    
    let ratingView = ImageViewBuilder.imageView(radius: 2.0, contentMode: .scaleAspectFit, clipsToBounds: true, userInteractionEnabled: false).build()
    let businessNameLabel = LabelBuilder.headerLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    let distanceLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: .right, sizeToFit: true).build()
    let reviewsLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: nil, sizeToFit: true).build()
    let priceLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: .right, sizeToFit: true).build()
    let addressLabel = LabelBuilder.subHeaderLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    let categoryLabel = LabelBuilder.caption1(textColor: .white, textAlignment: .center, sizeToFit: true).build()

    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Colors.white.color
        return v
    }()

    //MARK: Setup UI
    override func setUpViews() {
        
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
    
    //MARK: lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        businessImageView.image = nil
    }
    
    //MARK: Helper method for set data in cell
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
                self.businessImageView.image = #imageLiteral(resourceName: "placeholder")
                return
            }
            businessImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: true) { [weak self] (response) in
                
                guard let strongSelf = self else { return }
                guard let image = response.result.value else {
                    print("No image data in response Businesscell")
                    return
                }
                DispatchQueue.main.async {
                    strongSelf.businessImageView.image = image
                }
            }
    }
}












