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

final class BusinessesVC: SearchVC {
    
    //MARK: properties
    var dataSource = BusinessViewModelDataSource() { 
        didSet {
            self.dataSource.delegate = self
        }
    }
    var selection = Selection() {
        didSet {
            resetPriceAndRadius()
            self.filterView.selection = selection
            getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
        }
    }
    
    //MARK: this property handles the layout change on animation.
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
        let av = AlertView(message: "No Results, Sorry!", image: #imageLiteral(resourceName: "userPlaceholder"))
        av.alpha = 0
        return av
    }()
    
    lazy var mapView: CustomMapView = {
        let cmv = CustomMapView()
        cmv.isHidden = true
        cmv.delegate = self
        return cmv
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

    //MARK: Overriding SearchVC super class methods
    override func setUpTableView() {
        
        view.addSubview(tableView)
        tableView.register(BusinessCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.insertSubview(feedRefreshControl, at: 0)
        tableView.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
    }
    
    override func setUpNavBar() {
        super.setUpNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "FILTER", style: .plain, target: self, action: #selector(showFilterView))
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        
        getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
    }
    
    override func scrollViewIsDragging() {
        super.scrollViewIsDragging()
        
        performDismissFilterView()
    }
    
    //MARK: Super class SearchVC methods End.
    
    //MARK: Set up UI.
    private func setUpViews() {
        
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(mapView)
        view.addSubview(customIndicator)
        view.addSubview(segmentedControl)
        view.addSubview(alertView)
        view.addSubview(filterView)
        
        //MARK: add the constraints of filterview outside layoutSubviews to avoid constraint issues on animation.
        filterView.heightAnchor.constraint(equalToConstant: Constants.UI.filterViewHeight).isActive = true
        filterView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        filterView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        filterViewTopAnchor = filterView.topAnchor.constraint(equalTo: view.bottomAnchor)
        filterViewTopAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            
            alertView.heightAnchor.constraint(equalTo: view.heightAnchor),
            alertView.leftAnchor.constraint(equalTo: view.leftAnchor),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor),
            alertView.topAnchor.constraint(equalTo: view.topAnchor),
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
    }
    
    //MARK: segmented control switch from map to list
    @objc private func switchPresentation() {
        
        feedSearchBar.endEditing(true)
        mapView.isHidden = segmentedControl.selectedSegmentIndex == 0 ? true : false
        if segmentedControl.selectedSegmentIndex == 1 {
            updateMapWithDataSource()
        }
    }
    
    //MARK: Networking call 
    func getBusinesses<S: Gettable>(fromService service: S, withSelection selection: Selection) where S.T == BusinessViewModelDataSource {
        
        customIndicator.startAnimating()
        service.getBusinessesFrom(selection: selection) { [weak self] (result) in
            
            guard let strongSelf = self else {
                print("SELF IS NIL IN BUSINESSFEEDVC")
                return
            }
            switch result {
            case .Success(let businessViewModelDataSource):
                DispatchQueue.main.async {
                    strongSelf.dataSource = businessViewModelDataSource
                    strongSelf.mapView.dataSource = businessViewModelDataSource
                    
                    //setting the searchVC property of the datasource object to make the dataSource object adopt SearchVC delegation
                    strongSelf.dataSource.searchVC = self
                    strongSelf.tableView.registerDatasource(strongSelf.dataSource, completion: { (complete) in
                        strongSelf.feedRefreshControl.endRefreshing()
                        strongSelf.customIndicator.stopAnimating()
                    })
                }
            case .Error(let error) :
                print("ERROR ON NETWORK REQUEST FROM BUSINESSFEEDVC: \(error)")
                strongSelf.alertUserOfError()
            }
        }
    }
    
    func alertUserOfError() {
        showAlertWith(title: "Sorry", message: "Something went wrong, pull to refresh or try later", style: .alert)
    }
    
    //MARK: helper method
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.customIndicator.stopAnimating()
            strongSelf.feedRefreshControl.endRefreshing()

        }
        alertController.addAction(action)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: reset radius and price state for default search
    private func resetPriceAndRadius() {
        selection.radius = nil
        selection.price = nil
    }
}

//MARK: Map markers logic
extension BusinessesVC {
    
    //MARK: update markers in map
    fileprivate func updateMapWithDataSource() {
        mapView.setUpMapWith(dataSource)
    }
}

//MARK: tableview delegate method/ triggers navigation
extension BusinessesVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        feedSearchBar.endEditing(true)
        let businessViewModel = dataSource.getBusinessViewModelFrom(indexPath)
        let businessDetailVC = BusinessDetailVC()
        businessDetailVC.businessViewModel = businessViewModel
        self.present(businessDetailVC, animated: true)
    }
}

//MARK: BusinessViewModelDataSourceDelegate delegate methods
extension BusinessesVC: BusinessViewModelDataSourceDelegate {
    
    func handleNoResults() {
        
        DispatchQueue.main.async { [weak self] in
            self?.alertView.alpha = 1
            self?.alertView.performAnimation()
            self?.navigationItem.rightBarButtonItem = nil
            self?.navigationItem.titleView = nil
        }
    }
    
    func updateUIandData() {
        
        updateMapWithDataSource()
        performDismissFilterView()
        
    }
}

//MARK: FilterViewDelegate methods and FilterView actions
extension BusinessesVC: FilterViewDelegate {
    
    //triggered by vc nav bar right button
    @objc fileprivate func showFilterView() {
        
        //set selection property of filterView
        filterView.selection = selection
        filterViewTopAnchor?.constant = -Constants.UI.filterViewHeight
        self.feedSearchBar.endEditing(true)
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    //MARK: methods triggered by delegation
    func cancelWasPressed() {
        performDismissFilterView()
    }
    
    func searchWasPressedWithUpdatedSelection(_ selection: Selection) {
        
        customIndicator.startAnimating()
        alertView.alpha = 0
        getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
        performDismissFilterView()
    }
    
    //MARK: helper Method
    fileprivate func performDismissFilterView() {
        
        filterViewTopAnchor?.constant = view.frame.size.height
            UIView.animate(withDuration: 0.8, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
    }
}

//MARK: CustomMapViewDelegate delegate methods
extension BusinessesVC: CustomMapViewDelegate {

    func presentDetailVCFromMarker(with viewModel: BusinessViewModel) {
        
        feedSearchBar.endEditing(true)
        let businessDetailVC = BusinessDetailVC()
        businessDetailVC.businessViewModel = viewModel
        self.present(businessDetailVC, animated: true)
    }
    
    func hideKeyBoard() {
        feedSearchBar.endEditing(true)
        performDismissFilterView()
    }
}













