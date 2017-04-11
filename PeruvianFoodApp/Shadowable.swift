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

//public class EdgeShadowLayer: CAGradientLayer {
//    
//    public enum Edge {
//        case Top
//        case Left
//        case Bottom
//        case Right
//    }
//    
//    public init(forView viewFrame: CGRect,
//                edge: Edge = Edge.Top,
//                shadowRadius radius: CGFloat = 8.0,
//                toColor: UIColor = UIColor.white,
//                fromColor: UIColor = UIColor.black) {
//        super.init()
//        self.colors = [fromColor.cgColor, toColor.cgColor]
//        self.shadowRadius = radius
//        
//        //let viewFrame = view.frame
//        
//        switch edge {
//        case .Top:
//            startPoint = CGPoint(x: 0.5, y: 0.0)
//            endPoint = CGPoint(x: 0.5, y: 1.0)
//            self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
//        case .Bottom:
//            startPoint = CGPoint(x: 0.5, y: 1.0)
//            endPoint = CGPoint(x: 0.5, y: 0.0)
//            self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width, height: shadowRadius)
//        case .Left:
//            startPoint = CGPoint(x: 0.0, y: 0.5)
//            endPoint = CGPoint(x: 1.0, y: 0.5)
//            self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
//        case .Right:
//            startPoint = CGPoint(x: 1.0, y: 0.5)
//            endPoint = CGPoint(x: 0.0, y: 0.5)
//            self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
//        }
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
