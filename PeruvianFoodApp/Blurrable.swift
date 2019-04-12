//
//  Blurrable.swift
//  MoviesApp
//
//  Created by James Rochabrun on 3/21/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Blurrable {}

extension Blurrable where Self: UIView {
    
    func blur(with style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.bounds = self.bounds
        addSubview(blurEffectView)
    }
}

extension UIView: Blurrable {}






















