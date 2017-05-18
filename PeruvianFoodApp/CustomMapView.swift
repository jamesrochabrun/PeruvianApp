//
//  MapManagerView.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/19/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

protocol CustomMapViewDelegate: class {
    func presentDetailVCFromMarker(with viewModel: BusinessViewModel)
    func hideKeyBoard()
}

class CustomMapView: BaseView {
    
    //MARK: Properties
    var dataSource: BusinessViewModelDataSource? {
        didSet {
            if let mapDataSource = dataSource {
                setUpMapWith(mapDataSource)
            }
        }
    }
    weak var delegate: CustomMapViewDelegate?
    lazy var mapView = GMSMapView()
    lazy var markerArray = [GMSMarker]()
    var dataSourceArray = [BusinessViewModel]()
    
    //MARK: Setup UI
    override func setUpViews() {
        
        addSubview(mapView)
        mapView.mapType = .normal
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.setMinZoom(10, maxZoom: 18)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.widthAnchor.constraint(equalTo: widthAnchor),
            mapView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
    //MARK: uodates the dataSource
    func setUpMapWith(_ dataSource: BusinessViewModelDataSource) {
        
        dataSourceArray = dataSource.getBusinessesForMap()
        guard let closestBusiness = dataSourceArray.first else {
            print("No first business founded")
            return
        }
        setUpCameraPositionFromClosestBusiness(closestBusiness)
        resetMarkers(dataSourceArray)
    }
    
    //MARK: Helper methods. Marker LifeCycle
    
    //Update Camera position to the closest businees to the coordiantes
    private func setUpCameraPositionFromClosestBusiness(_ business: BusinessViewModel) {
        
        let camera = GMSCameraPosition.camera(withLatitude: business.coordinates.latitude, longitude: business.coordinates.longitude, zoom: 16)
        mapView.camera = camera
    }
    
    //Reset markers state
    private func resetMarkers(_ dataSourceArray: [BusinessViewModel]) {
        
        if markerArray.count <= 0 {
            _ = dataSourceArray.map{ setUpMarkerDataWith($0) }
        } else {
            for i in 0..<markerArray.count {
                let marker = markerArray[i]
                marker.map = nil
            }
            markerArray.removeAll()
            _ = dataSourceArray.map{setUpMarkerDataWith($0)}
        }
    }
    //Set up Markers
    private func setUpMarkerDataWith(_ viewModel: BusinessViewModel) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "markerIcon")
        marker.map = nil
        
        DispatchQueue.main.async {
            marker.title = viewModel.name
            marker.snippet = viewModel.textRating
        }
        markerArray.append(marker)
        draw(marker)
    }
    //Draw markers
    private func draw(_ marker: GMSMarker) {
        if marker.map == nil {
            marker.map = self.mapView
        }
    }
}

//MARK: GMSMapViewDelegate delegate methods
extension CustomMapView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        return MarkerDetailView(frame: frame, marker: marker)
    }
    
    //comparing coordinates (like choosing a cell in a tableView, instead of index coordinates)
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let selectedItemArray = dataSourceArray.filter({$0.coordinates.longitude == marker.position.longitude && $0.coordinates.latitude == marker.position.latitude})
        guard let businessViewModel = selectedItemArray.first else {
            return
        }
        delegate?.presentDetailVCFromMarker(with: businessViewModel)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            delegate?.hideKeyBoard()
        }
    }
}








