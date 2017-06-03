//
//  AnimatedLoadingView.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 6/2/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class AnimatedLoadingView: BaseView {
    
    //MARK: properties
    var animationView: LOTAnimationView?
    
    //MARK: initializer
    convenience init(name: String, speed: CGFloat, loop: Bool) {
        self.init()
        self.animationView = LOTAnimationView(name: name)
        setUpAnimationViewWith(speed: speed, loop: loop)
    }
    
    //MARK: Setup Animatedview
    func setUpAnimationViewWith(speed: CGFloat, loop: Bool) {
        
        guard let animationView = self.animationView else { return }
        animationView.contentMode = .scaleAspectFill
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animationSpeed = speed
        animationView.loopAnimation = loop
        addSubview(animationView)
        NSLayoutConstraint.activate([
            
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.leftAnchor.constraint(equalTo: leftAnchor),
            animationView.heightAnchor.constraint(equalTo: heightAnchor),
            animationView.widthAnchor.constraint(equalTo: widthAnchor)
            ])
    }
}
