//
//  StreetViewVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/19/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class StreetViewVC: UIViewController {
    
    //MARK: properties
    var businessViewModel: BusinessViewModel? {
        didSet {
            if let viewModel = businessViewModel {
                setUpStreetViewWith(viewModel)
            }
        }
    }
    
    //MARK: UI Elements
    lazy var dismissButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appSecondaryColor)
        b.layer.cornerRadius = 35
        b.layer.masksToBounds = true
        b.setTitle("X", for: .normal)
        b.setTitleColor(UIColor.hexStringToUIColor(Constants.Colors.white) , for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return b
    }()
    
    let panoramaView: GMSPanoramaView = {
        let pv = GMSPanoramaView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    let statusBarBackgroundView: BaseView = {
        let v = BaseView()
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        return v
    }()
    
    //MARK: APP lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.streetViewBackgroundColor)
        setUpViews()
    }
    
    //MARK: Setup UI
    fileprivate func setUpViews() {
        view.addSubview(statusBarBackgroundView)
        view.addSubview(panoramaView)
        view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            statusBarBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusBarBackgroundView.heightAnchor.constraint(equalToConstant: 22),
            statusBarBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 70),
            dismissButton.widthAnchor.constraint(equalToConstant: 70),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            panoramaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panoramaView.widthAnchor.constraint(equalTo: view.widthAnchor),
            panoramaView.topAnchor.constraint(equalTo: statusBarBackgroundView.bottomAnchor),
            panoramaView.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
    }
    
    //MARK: navigation
    @objc private func dismissView() {
        dismiss(animated: true)
    }
}

//MARK: Streetview handler
extension StreetViewVC {
    
    fileprivate func setUpStreetViewWith(_ viewModel: BusinessViewModel) {
        
        let panoramaService = GMSPanoramaService()
        let coordinate = CLLocationCoordinate2DMake(viewModel.coordinates.latitude, viewModel.coordinates.longitude)
        panoramaService.requestPanoramaNearCoordinate(coordinate) { [weak self] (panorama, error) in
            
            let camera = GMSPanoramaCamera.init(heading: 180, pitch: 0, zoom: 1, fov: 90)
            self?.panoramaView.camera = camera
            self?.panoramaView.panorama = panorama
            if self?.panoramaView.panorama == nil {
                self?.alertUserIfPanoramaIsNil()
            }
        }
    }
    
    private func alertUserIfPanoramaIsNil() {
        
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "No data Available", message: "Sorry, Google can't show data for this point.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
                alertController.dismiss(animated: true)
            }
            alertController.addAction(dismissAction)
            self?.present(alertController, animated: true)
        }
    }
}
