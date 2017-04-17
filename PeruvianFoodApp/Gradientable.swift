//
//  Gradientable.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Gradientable {}

extension Gradientable where Self: UIView {
    
    func gradient(withStartColor startColor: Colors, endColor: Colors, isHorizontal: Bool, isFlipped: Bool) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.isGeometryFlipped = isFlipped
        gradient.colors = [startColor.color().cgColor , endColor.color().cgColor]
        layer.insertSublayer(gradient, at: 0)
        if isHorizontal {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
    }
    
    //MARK: This handle iphone rotation
    //    func updateGradientSizeWith(_ size: CGSize) {
    //        DispatchQueue.main.async {
    //            self.gradient.frame = CGRect(x: 0, y: 0, width: size.width, height: self.bounds.height)
    //        }
    //    }
    
}

extension UIView: Gradientable {}





