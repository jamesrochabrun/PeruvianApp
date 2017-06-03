//
//  SplashVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 6/2/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class SplashVC: UIViewController {
    
    let animatedView: AnimatedLoadingView = {
        let av = AnimatedLoadingView(name: Constants.AnimationFiles.bounchingBall, speed: 0.8, loop: true)
        return av
    }()
    
    //MARK: App lifeCycel
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        self.perform(#selector(startApplication), with: self, afterDelay: 1.5)
        setUpViews()
    }
    
    func startApplication() {
        let ctc = CustomTabBarController()
        ctc.modalPresentationStyle = .custom
        ctc.modalTransitionStyle = .crossDissolve
        self.present(ctc, animated: true) {
            self.animatedView.stopAnimation()
        }
    }
    
    func setUpViews() {

        view.addSubview(animatedView)
        animatedView.startAnimation()
        NSLayoutConstraint.activate([
            animatedView.widthAnchor.constraint(equalToConstant: 300),
            animatedView.heightAnchor.constraint(equalToConstant: 300),
            animatedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
}




















