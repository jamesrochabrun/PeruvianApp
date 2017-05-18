//
//  Shadowable.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Shadowable {}

extension Shadowable where Self: UIView {
    
    func addTopShadowWith(radius: CGFloat, fromColor: UIColor, toColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: radius)
        layer.addSublayer(gradientLayer)
    }
}

extension UIView: Shadowable {}
