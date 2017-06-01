//
//  Scalable.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Scalable {}

extension Scalable where Self: UIImage {
    
    func scaleTo(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImage: Scalable {}
