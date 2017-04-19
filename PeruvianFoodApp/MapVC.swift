//
//  MapVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit

class MapVC: UIViewController {
    
    var businessViewModel: BusinessViewModel? {
        didSet {
            if let viewModel = businessViewModel {
                setUpGoogleMapWith(viewModel)
            }
        }
    }
    var googleMap = GMSMapView()
    
    //MARK: UI Elements
    let statusBarBackgroundView: BaseView = {
        let v = BaseView()
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        return v
    }()
    
    let dismissButton: CustomDismissButton = {
        let dbv = CustomDismissButton()
        return dbv
    }()
    
    //MARK: APP lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name.dismissViewNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            statusBarBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusBarBackgroundView.heightAnchor.constraint(equalToConstant: 22),
            statusBarBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            dismissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            dismissButton.topAnchor.constraint(equalTo: statusBarBackgroundView.bottomAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: Constants.UI.dismissButtonHeight),
            dismissButton.widthAnchor.constraint(equalToConstant: Constants.UI.dismissButtonWidth),
            googleMap.topAnchor.constraint(equalTo: view.topAnchor),
            googleMap.heightAnchor.constraint(equalTo: view.heightAnchor),
            googleMap.widthAnchor.constraint(equalTo: view.widthAnchor),
            googleMap.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
    }
    
    //MARK: Navigation
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    //MARK: setup UI
    fileprivate func setUpViews() {
        view.addSubview(googleMap)
        view.addSubview(statusBarBackgroundView)
        view.addSubview(dismissButton)
    }
}

//MARK: google maps

extension MapVC {
    
    fileprivate func setUpGoogleMapWith(_ viewModel: BusinessViewModel) {
        
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude, zoom: 16)
        googleMap = GMSMapView.map(withFrame: .zero, camera: camera)
        googleMap.mapType = .normal
        googleMap.isMyLocationEnabled = true
        googleMap.settings.compassButton = true
        googleMap.settings.myLocationButton = true
        googleMap.setMinZoom(10, maxZoom: 18)
        googleMap.translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        setUpMarkerDataWith(viewModel)
    }
    
    private func setUpMarkerDataWith(_ viewModel: BusinessViewModel) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "markerIcon")
        marker.map = nil
        
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(marker.position) { (response, error) in
            marker.title = response?.firstResult()?.locality
            marker.snippet = response?.firstResult()?.thoroughfare
        }
        draw(marker)
    }
    
    private func draw(_ marker: GMSMarker) {
        
        if marker.map == nil {
            marker.map = self.googleMap
        }
    }
}












