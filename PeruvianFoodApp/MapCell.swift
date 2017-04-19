//
//  MapCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapCell: BaseCell {
    
    var googleMap = GMSMapView()
    lazy var actionView: BaseView = {
        let v = BaseView()
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnMap)))
        v.isUserInteractionEnabled = true
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            actionView.topAnchor.constraint(equalTo: topAnchor),
            actionView.leftAnchor.constraint(equalTo: leftAnchor),
            actionView.widthAnchor.constraint(equalTo: widthAnchor),
            actionView.heightAnchor.constraint(equalTo: heightAnchor),
            googleMap.topAnchor.constraint(equalTo: topAnchor),
            googleMap.leftAnchor.constraint(equalTo: leftAnchor),
            googleMap.widthAnchor.constraint(equalTo: widthAnchor),
            googleMap.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
    func setUpGoogleMapWith(_ viewModel: BusinessViewModel) {
        
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude, zoom: 16)
        googleMap = GMSMapView.map(withFrame: .zero, camera: camera)
        googleMap.mapType = .normal
        googleMap.translatesAutoresizingMaskIntoConstraints = false
        addSubview(googleMap)
        addSubview(actionView)
        setUpMarkerDataWith(viewModel)
    }
    
    private func setUpMarkerDataWith(_ viewModel: BusinessViewModel) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "markerIcon")
        marker.map = nil
        draw(marker)
    }
    
    private func draw(_ marker: GMSMarker) {
        
        if marker.map == nil {
            marker.map = self.googleMap
        }
    }
    
    @objc private func handleTapOnMap() {
        NotificationCenter.default.post(name: Notification.Name.openMapVCNotification, object: nil)
    }
}






