//
//  BusinessFeedVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import TRON
import SwiftyJSON

import GoogleMaps

class BusinessesFeedVC: FeedVC {
    
    //MARK: properties
    var feedDataSource = BusinessViewModelDataSource() {
        didSet {
            self.feedDataSource.delegate = self
        }
    }
    var selection = Selection() {
        didSet {
            resetPriceAndRadius()
            self.filterView.selection = selection
            getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
        }
    }
    
    //MARK: clean radius and price for default search
    private func resetPriceAndRadius() {
        selection.radius = nil
        selection.price = nil
    }
    
    var filterViewTopAnchor: NSLayoutConstraint?
    
    //MARK: UI elements
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.hexStringToUIColor(Constants.Colors.appSecondaryColor)
        sc.insertSegment(withTitle: "LIST", at: 0, animated: true)
        sc.insertSegment(withTitle: "MAP", at: 1, animated: true)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.addTarget(self, action: #selector(switchPresentation), for: .valueChanged)
        return sc
    }()
    
    lazy var filterView: FilterView = {
        let v = FilterView()
        v.delegate = self
        return v
    }()
    
    let alertView: AlertView = {
        let av = AlertView(message: "No food results", image: #imageLiteral(resourceName: "Jelly"))
        av.alpha = 0
        return av
    }()
    
    let mapView: MapManagerView = {
        let mv = MapManagerView()
        mv.isHidden = true
        return mv
    }()
    
    //MARK: APP lifecycle
    override func viewDidLoad() {

        setUpNavBar()
        setUpTableView()
        setUpViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        feedSearchBar.endEditing(true)
        performDismissFilterView()
    }
    
    //MARK: FeedVC super class methods
    override func setUpTableView() {
        
        view.addSubview(tableView)
        tableView.addSubview(customIndicator)
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.insertSubview(feedRefreshControl, at: 0)
    }
    
    override func setUpViews() {
        
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(mapView)
        view.addSubview(segmentedControl)
        view.addSubview(alertView)
        view.addSubview(filterView)
        
        //add the constraints here to avoid the call to layout if needed during animation
        filterView.heightAnchor.constraint(equalToConstant: Constants.UI.filterViewHeight).isActive = true
        filterView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        filterView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        filterViewTopAnchor = filterView.topAnchor.constraint(equalTo: view.bottomAnchor)
        filterViewTopAnchor?.isActive = true
        
        customIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            alertView.heightAnchor.constraint(equalTo: view.heightAnchor),
            alertView.leftAnchor.constraint(equalTo: view.leftAnchor),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor),
            alertView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
    }
    
    override func setUpNavBar() {
        super.setUpNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "FILTER", style: .plain, target: self, action: #selector(showFilterView))
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
    }
    
    //MARK: segmented control trigger
    @objc private func switchPresentation() {
        
        mapView.isHidden = segmentedControl.selectedSegmentIndex == 0 ? true : false
        if segmentedControl.selectedSegmentIndex == 1 {
            mapView.mapDataSource = feedDataSource
        }
    }
    
    //MARK: Networking
    fileprivate func getBusinesses<S: Gettable>(fromService service: S, withSelection selection: Selection) where S.T == BusinessViewModelDataSource {
        
        service.getBusinessesFrom(selection: selection) { [weak self] (result) in
            
            guard let strongSelf = self else {
                print("SELF IS NIL IN BUSINESSFEEDVC")
                return }
            
            switch result {
            case .Success(let businessViewModelDataSource):
                DispatchQueue.main.async {
                    strongSelf.feedDataSource = businessViewModelDataSource
                   // strongSelf.mapView.mapDataSource = businessViewModelDataSource
                    //setting the feedVC property of the datasource object
                    strongSelf.feedDataSource.feedVC = self
                    //////////////////////////////////////////////////////
                    strongSelf.tableView.registerDatasource(strongSelf.feedDataSource, completion: { (complete) in
                        strongSelf.feedRefreshControl.endRefreshing()
                        strongSelf.customIndicator.stopAnimating()
                    })
                }
            case .Error(let error) :
                print("ERROR ON NETWORK REQUEST FROM BUSINESSFEEDVC: \(error)")
            }
        }
    }
}

//MARK: tableview delegate method
extension BusinessesFeedVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        feedSearchBar.endEditing(true)
        let businessViewModel = feedDataSource.getBusinessViewModelFromIndexpath(indexPath)
        let businessDetailVC = BusinessDetailVC()
        businessDetailVC.businessViewModel = businessViewModel
        self.present(businessDetailVC, animated: true)
    }
}

//MARK: BusinessDatasourcedelegate
extension BusinessesFeedVC: BusinessViewModelDataSourceDelegate {
    
    func handleNoResults() {
        alertView.alpha = 1
        alertView.performAnimation()
    }
}

//MARK: Show filter view

extension BusinessesFeedVC: FilterViewDelegate {
    
    //triggered by vc nav bar button
    @objc fileprivate func showFilterView() {
        
        filterView.selection = selection
        filterViewTopAnchor?.constant = -Constants.UI.filterViewHeight
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    //triggered by delegation
    func cancelWasPressed() {
        performDismissFilterView()
    }
    
    func searchWasPressedToUpdateSelection(_ selection: Selection) {
        
        customIndicator.startAnimating()
        alertView.alpha = 0
        getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
        performDismissFilterView()
    }
    
    //helper Method
    fileprivate func performDismissFilterView() {
        
        filterViewTopAnchor?.constant = view.frame.size.height
            UIView.animate(withDuration: 0.8, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
    }
}


class MapManagerView: BaseView {
    
    var mapDataSource: BusinessViewModelDataSource? {
        didSet {
            if let mapDataSource = mapDataSource {
                setUpMapWith(mapDataSource)
            }
        }
    }
    var markerArray = [GMSMarker]()
    var mapView: GMSMapView?
    
    override func setUpViews() {
        
        mapView = GMSMapView()
        mapView?.mapType = .normal
        mapView?.isMyLocationEnabled = true
        mapView?.settings.compassButton = true
        mapView?.settings.myLocationButton = true
        mapView?.setMinZoom(10, maxZoom: 18)
        mapView?.translatesAutoresizingMaskIntoConstraints = false

        if mapView == nil { return }
        addSubview(mapView!)
        NSLayoutConstraint.activate([
            mapView!.topAnchor.constraint(equalTo: topAnchor),
            mapView!.leftAnchor.constraint(equalTo: leftAnchor),
            mapView!.widthAnchor.constraint(equalTo: widthAnchor),
            mapView!.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
    private func setUpMapWith(_ dataSource: BusinessViewModelDataSource) {
        
        let dataSourceArray = dataSource.getBusinessesForMap()
        guard let closestBusiness = dataSourceArray.first else {
            print("No first business founded")
            return
        }
        setUpCameraPositionFromClosestBusiness(closestBusiness)
        resetAndDrawMarkersWith(dataSourceArray)
    }
    
    private func setUpCameraPositionFromClosestBusiness(_ business: BusinessViewModel) {
        
        let camera = GMSCameraPosition.camera(withLatitude: business.coordinates.latitude, longitude: business.coordinates.longitude, zoom: 16)
        mapView?.camera = camera
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
          //  _ = markerArray.map{draw($0)}
        }
    }
    
    private func setUpMarkerDataWith(_ viewModel: BusinessViewModel) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "markerIcon")
        marker.map = nil
        
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(marker.position) { (response, error) in
            marker.title = viewModel.name
            marker.snippet = response?.firstResult()?.thoroughfare
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



















