//
//  LottieAnimable.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 6/2/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol LottieAnimable {}

extension LottieAnimable where Self: AnimatedLoadingView {
    
    func startAnimation() {
        animationView?.play()
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
    }
    
    func stopAnimation() {
        animationView?.pause()
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        }
    }
}

extension AnimatedLoadingView: LottieAnimable {}
