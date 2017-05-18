//
//  AlertController.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController: Alertable {}
