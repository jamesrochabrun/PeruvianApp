//
//  InfoCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class InfoCell: BaseCell {
    
    let starIconIndicator: IconIndicatorView = {
        let siv = IconIndicatorView()
        siv.indicatorImageView.image = #imageLiteral(resourceName: "star").withRenderingMode(.alwaysTemplate)
        siv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        return siv
    }()
    
    let priceIndicator: IconIndicatorView = {
        let siv = IconIndicatorView()
        siv.indicatorImageView.image = #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate)
        siv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        return siv
    }()
    
    let distanceIndicator: IconIndicatorView = {
        let siv = IconIndicatorView()
        siv.indicatorImageView.image = #imageLiteral(resourceName: "distance").withRenderingMode(.alwaysTemplate)
        siv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        return siv
    }()
    
    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        return v
    }()
    
    override func setUpViews() {
        
        addSubview(dividerLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        addTopShadowWith(radius: 7.0, fromColor: UIColor.hexStringToUIColor(Constants.Colors.shadowColor), toColor: .white)
//        gradient(withStartColor: .appMainColor, endColor: .appSecondaryColor, isHorizontal: true, isFlipped: false)
        
        let iconsStackView = UIStackView(arrangedSubviews: [starIconIndicator, priceIndicator, distanceIndicator])
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        iconsStackView.axis = .horizontal
        iconsStackView.distribution = .fillEqually
        addSubview(iconsStackView)
        
        NSLayoutConstraint.activate([
            dividerLine.heightAnchor.constraint(equalToConstant: 0.5),
            dividerLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            iconsStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            iconsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            iconsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconsStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        
        starIconIndicator.indicatorLabel.text = businessViewModel.textRating
        priceIndicator.indicatorLabel.text = businessViewModel.price
        distanceIndicator.indicatorLabel.text = businessViewModel.distance
    }
}





