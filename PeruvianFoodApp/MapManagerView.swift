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

protocol MapManagerDelegate: class {
    func openDetailVCFromMarkerViewWith(_ viewModel: BusinessViewModel)
    func hideKeyBoard()
}

class MapManagerView: BaseView {
    
    var mapDataSource: BusinessViewModelDataSource? {
        didSet {
            if let mapDataSource = mapDataSource {
                setUpMapWith(mapDataSource)
            }
        }
    }
    lazy var markerArray = [GMSMarker]()
    weak var delegate: MapManagerDelegate?
    lazy var mapView = GMSMapView()
    var dataSourceArray: [BusinessViewModel]?
    
    override func setUpViews() {
        
        // mapView = GMSMapView()
        mapView.mapType = .normal
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.setMinZoom(10, maxZoom: 18)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.widthAnchor.constraint(equalTo: widthAnchor),
            mapView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
    //MARK: getbusinessesformap function updates a new array every time the BusinessViewModelDataSource is setted
    private func setUpMapWith(_ dataSource: BusinessViewModelDataSource) {
        
        dataSourceArray = dataSource.getBusinessesForMap()
        guard let closestBusiness = dataSourceArray?.first else {
            print("No first business founded")
            return
        }
        setUpCameraPositionFromClosestBusiness(closestBusiness)
        resetAndDrawMarkersWith(dataSourceArray!)
    }
    
    //MARK: Helper methods
    private func setUpCameraPositionFromClosestBusiness(_ business: BusinessViewModel) {
        
        let camera = GMSCameraPosition.camera(withLatitude: business.coordinates.latitude, longitude: business.coordinates.longitude, zoom: 16)
        mapView.camera = camera
    }
    
    private func resetAndDrawMarkersWith(_ dataSourceArray: [BusinessViewModel]) {
        
        if markerArray.count <= 0 {
            _ = dataSourceArray.map{setUpMarkerDataWith($0)}
            // _ = markerArray.map{draw($0)}
        } else {
            for i in 0..<markerArray.count {
                let marker = markerArray[i]
                marker.map = nil
            }
            markerArray.removeAll()
            _ = dataSourceArray.map{setUpMarkerDataWith($0)}
            // _ = markerArray.map{draw($0)}
        }
    }
    
    private func setUpMarkerDataWith(_ viewModel: BusinessViewModel) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "markerIcon")
        marker.map = nil
        
        DispatchQueue.main.async {
            marker.title = viewModel.name
            marker.snippet = viewModel.address
        }
        markerArray.append(marker)
        draw(marker)
    }
    
    private func draw(_ marker: GMSMarker) {
        if marker.map == nil {
            marker.map = self.mapView
        }
    }
}

extension MapManagerView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        return MarkerDetailView(frame: frame, marker: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        guard let filterArray = dataSourceArray?.filter({$0.coordinates.longitude == marker.position.longitude && $0.coordinates.latitude == marker.position.latitude}),
            let businessViewModel = filterArray.first else {
                return
        }
        delegate?.openDetailVCFromMarkerViewWith(businessViewModel)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            delegate?.hideKeyBoard()
        }
    }
}








