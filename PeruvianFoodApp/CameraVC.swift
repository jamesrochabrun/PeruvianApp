//
//  CameraVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class CameraVC: UIViewController {
    
    //MARK: UI elements
    lazy var cameraView: CameraView = {
        let v = CameraView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
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
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54)
            ])
    }
    
    //MARK: navigation
    func dismissView() {
        self.dismiss(animated: true)
    }
}

extension CameraVC: CameraViewDelegate {
    
    func showAlertAskingForSave(image: UIImage) {
        
        let alertController = UIAlertController(title: "Great photo", message: "Add to favorites?", preferredStyle:.alert)
        let save = UIAlertAction(title: "save", style: .default) { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
            self?.saveInCoreData(image)
        }
        let retake = UIAlertAction(title: "retake", style: .default) { [weak self] (action) in
            self?.cameraView.retake()
            alertController.dismiss(animated: true)
        }
        alertController.addAction(save)
        alertController.addAction(retake)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //MARK: helper methods

    func saveInCoreData(_ image: UIImage) {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
            photoEntity.image = UIImageJPEGRepresentation(image, 0.75) as NSData?
            photoEntity.date = NSDate()
        }
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}











