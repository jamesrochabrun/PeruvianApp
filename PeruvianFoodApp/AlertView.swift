//
//  AlertView.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/16/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class AlertView: BaseView {
    
    let alertLabel = LabelBuilder.headerLabel(textColor: .appSecondaryColor, textAlignment: .center, sizeToFit: true).build()
    let alertImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    convenience init(message: String, image: UIImage) {
        self.init()
        alertLabel.text = message
        alertImageView.image = image
    }
    
    override func setUpViews() {
        addSubview(alertLabel)
        addSubview(alertImageView)
        backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            alertImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            alertImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            alertImageView.heightAnchor.constraint(equalTo: alertImageView.widthAnchor),
            alertLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertLabel.topAnchor.constraint(equalTo: alertImageView.bottomAnchor, constant: 30),
            alertLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
            ])
    }
}

//MARK: Helper methods
extension AlertView {
    
    func performAnimation() {
        alertLabel.flash()
        alertImageView.jitter()
    }
}
















