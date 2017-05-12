//
//  ReviewCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


class ReviewCell: BaseCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        return iv
    }()
    
    let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var moreReviewsButton: UIButton = {
        let b = UIButton(type: .custom)
        b.setTitleColor(UIColor.hexStringToUIColor(Constants.Colors.appSecondaryColor), for: .normal)
        b.layer.borderColor = UIColor.hexStringToUIColor(Constants.Colors.appSecondaryColor).cgColor
        b.layer.borderWidth = 1.5
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("View More", for: .normal)
        b.addTarget(self, action: #selector(performHandler), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let reviewNameLabel = LabelBuilder.headerLabel(textColor: .grayTextColor, textAlignment: nil, sizeToFit: true).build()
    let reviewTextLabel = LabelBuilder.caption1(textColor: .grayTextColor, textAlignment: nil, sizeToFit: true).build()
    let reviewDateLabel = LabelBuilder.caption1(textColor: .grayTextColor, textAlignment: .right, sizeToFit: true).build()
    
    override func setUpViews() {
        selectionStyle = .none
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(reviewNameLabel)
        contentView.addSubview(reviewDateLabel)
        contentView.addSubview(reviewTextLabel)
        contentView.addSubview(ratingImageView)
        contentView.addSubview(moreReviewsButton)
        
        //less than 251 contenthugging
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
            
            moreReviewsButton.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            moreReviewsButton.widthAnchor.constraint(equalToConstant: 110),
            moreReviewsButton.topAnchor.constraint(equalTo: ratingImageView.topAnchor),
            moreReviewsButton.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
            ])
    }
    
    
    func setUp(with viewModel: ReviewViewModel) {
        
        dump(viewModel)
        
        if let profileImageURL = viewModel.profileImageURL {
            profileImageView.af_setImage(withURL: profileImageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false) { [weak self] (response) in
                guard let image = response.result.value else {
                    print("INVALID RESPONSE SETTING UP THE REVIEWCELL")
                    return
                }
                self?.profileImageView.image = image
            }
        }
        ratingImageView.image = viewModel.ratingImage
        reviewNameLabel.text = viewModel.userName
        reviewTextLabel.text = viewModel.text
        reviewDateLabel.text = viewModel.timeCreated
        //open url missing
    }
    
    @objc private func performHandler() {
        //open url here
    }
}


