//
//  CustomDismissButton.swift
//  MoviesApp
//
//  Created by James Rochabrun on 3/22/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CustomDismissButton: BaseView {
    
    lazy var button: UIButton = {
        return ButtonBuilder.customButton(tintColor: .appMainColor , image:#imageLiteral(resourceName: "dismiss") , target: self, selector: #selector(performHandler)).build()
    }()
    
    let xView: UIImageView = {
        let x = UIImageView()
        x.translatesAutoresizingMaskIntoConstraints = false
        x.image = #imageLiteral(resourceName: "x")
        return x
    }()
    
    override func setUpViews() {
        addSubview(button)
        addSubview(xView)
        
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: Constants.UI.dismissButtonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: Constants.UI.dismissButtonHeight).isActive = true
        
        xView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        xView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        xView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        xView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func performHandler() {
        NotificationCenter.default.post(name: Notification.Name.dismissViewNotification, object: nil)
    }
}



