//
//  YelpActivityIndicator.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/6/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CustomActivityIndicator: BaseView {
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appSecondaryColor)
        return v
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        actInd.hidesWhenStopped = true
        actInd.translatesAutoresizingMaskIntoConstraints = false
        actInd.style = .whiteLarge
      //  actInd.startAnimating()
        return actInd
    }()
    
    override func setUpViews() {
        
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: heightAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.alpha = 0
        }
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.alpha = 1
        }
    }
}





