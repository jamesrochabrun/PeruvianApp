//
//  Opaqueable.swift
//  MoviesApp
//
//  Created by James Rochabrun on 3/21/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Opaqueable {}

extension Opaqueable where Self: UIView {
    
    func opaque(with color: String, alpha: CGFloat) {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.hexStringToUIColor(color)
        overlay.alpha = alpha
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(overlay)
    }
}

extension UIView: Opaqueable {}


