//
//  MarkerDetailView.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

//MARK: Custom view for marker information
class MarkerDetailView: BaseView {
    
    let headerLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        l.textAlignment = .center
        return l
    }()
    
    let subHeaderLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.white)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.clipsToBounds = true
        return iv
    }()
    
    convenience init(frame: CGRect, marker: GMSMarker) {
        self.init(frame: frame)
        headerLabel.text = marker.title
        if let snippet = marker.snippet,
            let double = Double(snippet) {
            let numberIcon = NSNumber(value: double)
            ratingImageView.image = ReviewIcon(reviewNumber: numberIcon).image
        }
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = Colors.appMainColor.color 
        alpha = 0.8
    }
    
    override func setUpViews() {
        
        addSubview(headerLabel)
        addSubview(ratingImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = headerLabel.frame
        frame.origin.y = self.frame.origin.y + 8
        frame.size.height = 20
        frame.size.width = self.frame.size.width * 0.7
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2
        headerLabel.frame = frame
        
        frame = ratingImageView.frame
        frame.origin.y = headerLabel.frame.maxY + 7
        frame.size.width = self.frame.size.width * 0.7
        frame.size.height = 28
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2
        ratingImageView.frame = frame
    }
}







