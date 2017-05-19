//
//  CameraVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CameraVC: UIViewController {
    
    //MARK: UI elements
    let cameraView: CameraView = {
        let v = CameraView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var dismissButton: UIButton = {
        return ButtonBuilder.buttonWithImage(image: #imageLiteral(resourceName: "dismissX"), renderMode: true, tintColor: .cameraButtonBackgroundColor, target: self, selector: #selector(dismissView) , radius: 30).build()
    }()
    
    //MARK: App lifcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.addSubview(dismissButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            cameraView.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraView.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dismissButton.widthAnchor.constraint(equalToConstant: 60),
            dismissButton.heightAnchor.constraint(equalToConstant: 60),
            dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
            ])
    }
    
    //MARK: navigation
    func dismissView() {
        self.dismiss(animated: true)
    }
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        cameraView.didPressTakeAnother()
    //    }
}
