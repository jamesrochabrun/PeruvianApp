//
//  ReviewCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class ReviewCell: BaseCell {
    
    //MARK: UI Elements
    let profileImageView = ImageViewBuilder.imageView(radius: 40, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
    let ratingImageView = ImageViewBuilder.imageView(radius: nil, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
    
    let reviewNameLabel = LabelBuilder.headerLabel(textColor: .grayTextColor, textAlignment: nil, sizeToFit: true).build()
    let reviewTextLabel = LabelBuilder.caption1(textColor: .grayTextColor, textAlignment: nil, sizeToFit: true).build()
    let reviewDateLabel = LabelBuilder.caption1(textColor: .grayTextColor, textAlignment: .right, sizeToFit: true).build()
    
    //MARK: Setup UI
    override func setUpViews() {
        selectionStyle = .none
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(reviewNameLabel)
        contentView.addSubview(reviewDateLabel)
        contentView.addSubview(reviewTextLabel)
        contentView.addSubview(ratingImageView)
        
        //less than 251 content hugging
        reviewNameLabel.setContentHuggingPriority(250, for: .horizontal)
        //greater than 751 compression
        reviewDateLabel.setContentCompressionResistancePriority(751, for: .horizontal)
        
        NSLayoutConstraint.activate([
            
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 8),
            profileImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            
            reviewNameLabel.topAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            reviewNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8),
            reviewNameLabel.rightAnchor.constraint(equalTo: reviewDateLabel.leftAnchor, constant: -8),
            
            reviewDateLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            reviewDateLabel.topAnchor.constraint(equalTo: reviewNameLabel.topAnchor),
            
            reviewTextLabel.leftAnchor.constraint(equalTo: reviewNameLabel.leftAnchor),
            reviewTextLabel.rightAnchor.constraint(equalTo: reviewDateLabel.rightAnchor),
            reviewTextLabel.topAnchor.constraint(equalTo: reviewNameLabel.bottomAnchor, constant: 8),
            
            ratingImageView.heightAnchor.constraint(equalToConstant: 20),
            ratingImageView.widthAnchor.constraint(equalToConstant: 110),
            ratingImageView.topAnchor.constraint(equalTo: reviewTextLabel.bottomAnchor, constant: 8),
            ratingImageView.leftAnchor.constraint(equalTo: reviewNameLabel.leftAnchor),
            ratingImageView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
            ])
    }
    
    //MARK: Helper method for set up cell data
    func setUp(with viewModel: ReviewViewModel) {
        
        //Alamofire image
        if let profileImageURL = viewModel.profileImageURL {
            profileImageView.af_setImage(withURL: profileImageURL, placeholderImage: #imageLiteral(resourceName: "userPlaceholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false) { [weak self] (response) in
                guard let image = response.result.value else {
                    print("INVALID RESPONSE SETTING UP THE REVIEWCELL")
                    return
                }
                DispatchQueue.main.async {
                self?.profileImageView.image = image
                }
            }
        } else {
            self.profileImageView.image = #imageLiteral(resourceName: "userPlaceholder")
        }
        ratingImageView.image = viewModel.ratingImage
        reviewNameLabel.text = viewModel.userName
        reviewTextLabel.text = viewModel.text
        reviewDateLabel.text = viewModel.timeCreated
    }
    
}


