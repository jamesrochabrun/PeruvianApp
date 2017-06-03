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
    
    //MARK: App lifeCycel
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringToUIColor("662D8C")
        self.perform(#selector(startApplication), with: self, afterDelay: 0.8)
        startAnimation()
    }
    
    func startApplication() {
        let ctc = CustomTabBarController()
        ctc.modalPresentationStyle = .custom
        ctc.modalTransitionStyle = .crossDissolve
        self.present(ctc, animated: true, completion: nil)
    }
    
    func startAnimation() {
        
        guard let animationView = LOTAnimationView(name: "finish") else { return }
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
      //  animationView.animationSpeed = 0.8
       // animationView.loopAnimation = true
        view.addSubview(animationView)
        animationView.play()
        
    }
}
