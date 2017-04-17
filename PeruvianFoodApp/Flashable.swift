//
//  Flashable.swift
//  JellyJitterable
//
//  Created by James Rochabrun on 3/17/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Flashable {}

extension Flashable where Self: UIView {
    
    func flash() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { (complete) in
            if complete {
                UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
                    self.alpha = 0
                }, completion: nil)
            }
        })
    }
}

extension UIView: Flashable {}
