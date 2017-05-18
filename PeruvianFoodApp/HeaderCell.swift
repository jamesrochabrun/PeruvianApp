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
    
    //MARK: UI Elements
    let businessImageView = ImageViewBuilder.imageView(radius: nil, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
    let businessNameLabel = LabelBuilder.headerLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    
    let overlayView: BaseView = {
        let v = BaseView()
        v.blur(with : .light)
        v.opaque(with: Constants.Colors.darkTextColor, alpha: 0.05)
        return v
    }()
    let ratingImageView = ImageViewBuilder.imageView(radius: nil, contentMode: .center, clipsToBounds: true, userInteractionEnabled: false).build()
    
    //MARK: Set up UI
    override func setUpViews() {
        
        addSubview(businessImageView)
        addSubview(overlayView)
        addSubview(businessNameLabel)
        addSubview(ratingImageView)
        
        NSLayoutConstraint.activate([
            
            businessImageView.widthAnchor.constraint(equalTo: widthAnchor),
            businessImageView.heightAnchor.constraint(equalTo: heightAnchor),
            businessImageView.leftAnchor.constraint(equalTo: leftAnchor),
            businessImageView.topAnchor.constraint(equalTo: topAnchor),
            
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
    
    //MARK: Helper method to set up cell data
    func setUp(with businessViewModel: BusinessViewModel) {

        guard let url = URL(string: businessViewModel.profileImageURL) else {
            print("INVALID URL ON CREATION HEADERCELL")
            return
        }
        businessImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false) { [unowned self] (response) in
            guard let image = response.result.value else {
                print("INVALID RESPONSE SETTING UP THE HEADERCELL")
                return
            }
            self.businessImageView.image = image
        }
        businessNameLabel.text = businessViewModel.name
        ratingImageView.image = businessViewModel.ratingImage
    }
}











