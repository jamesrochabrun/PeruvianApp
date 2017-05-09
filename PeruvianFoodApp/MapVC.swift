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
    
    //MARK: Properties
    var businessViewModel: BusinessViewModel? {
        didSet {
            if let viewModel = businessViewModel {
                setUpGoogleMapWith(viewModel)
            }
        }
    }
    var polyline: GMSPolyline?
    var googleMap: GMSMapView?
    let circularTransition = CircularTransition()
    
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
    
    lazy var transitionButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.streetViewBackgroundColor)
        b.layer.cornerRadius = 35
        b.layer.masksToBounds = true
        b.setTitle("S", for: .normal)
        b.setTitleColor(UIColor.hexStringToUIColor(Constants.Colors.white) , for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(goToStreetView), for: .touchUpInside)
        return b
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
        googleMap?.selectedMarker = nil
        googleMap = nil
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
            transitionButton.heightAnchor.constraint(equalToConstant: 70),
            transitionButton.widthAnchor.constraint(equalToConstant: 70),
            transitionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transitionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
            ])
    }
    
    //MARK: Navigation
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc private func goToStreetView() {
        
        let streetVC = StreetViewVC()
        streetVC.transitioningDelegate = self
        streetVC.modalPresentationStyle = .custom
        streetVC.businessViewModel = businessViewModel
        present(streetVC, animated: true)
    }
    
    //MARK: setup UI
    fileprivate func setUpViews() {
       // view.addSubview(googleMap)
        view = googleMap
        view.addSubview(statusBarBackgroundView)
        view.addSubview(dismissButton)
        view.addSubview(transitionButton)
    }
}

//MARK: google maps handlers setup
extension MapVC {
    
    fileprivate func setUpGoogleMapWith(_ viewModel: BusinessViewModel) {
        
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude, zoom: 16)
        googleMap = GMSMapView.map(withFrame: .zero, camera: camera)
        googleMap?.mapType = .normal
        googleMap?.delegate = self
        googleMap?.isMyLocationEnabled = true
        googleMap?.settings.compassButton = true
        googleMap?.settings.myLocationButton = true
        googleMap?.setMinZoom(10, maxZoom: 18)
        setUpViews()
        setUpMarkerDataWith(viewModel)
    }
    
    private func setUpMarkerDataWith(_ viewModel: BusinessViewModel) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "markerIcon")
        marker.map = nil
        marker.title = viewModel.name
        marker.snippet = viewModel.textRating
        draw(marker)
    }
    
    private func draw(_ marker: GMSMarker) {
        
        if marker.map == nil {
            marker.map = self.googleMap
        }
    }
}

extension MapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        return MarkerDetailView(frame: frame, marker: marker)
    }
    
    //MARK: Polyline
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        if self.polyline != nil { return }
        
        GoogleMapService.getDirectionsFrom(mapView: mapView, marker: marker) { (result) in
            
            self.polyline?.map = nil
            self.polyline = nil
            switch result {
            case .Success(let path):
                self.polyline = GMSPolyline.init(path: path)
                self.polyline?.strokeColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
                self.polyline?.strokeWidth = 3.0
                self.polyline?.map = self.googleMap
            case .Error(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.polyline?.map = nil
        self.polyline = nil
    }
}

//MARK: Trabsition delegate
extension MapVC: UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        circularTransition.transitionMode = .present
        circularTransition.startingPoint = transitionButton.center
        circularTransition.circleColor = UIColor.hexStringToUIColor(Constants.Colors.streetViewBackgroundColor) //transitionButton.backgroundColor!
        return circularTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        circularTransition.transitionMode = .dismiss
        circularTransition.startingPoint = transitionButton.center
        circularTransition.circleColor = UIColor.hexStringToUIColor(Constants.Colors.streetViewBackgroundColor)//transitionButton.backgroundColor!
        return circularTransition
    }
}



















