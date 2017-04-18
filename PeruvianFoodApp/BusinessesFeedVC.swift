//
//  BusinessFeedVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import TRON
import SwiftyJSON

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
        tableView.separatorStyle = .none
        tableView.insertSubview(feedRefreshControl, at: 0)
    }
    
    override func setUpViews() {
        
        segmentedControl.selectedSegmentIndex = 0
        tableView.tableHeaderView = segmentedControl
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
            alertView.heightAnchor.constraint(equalTo: view.heightAnchor),
            alertView.leftAnchor.constraint(equalTo: view.leftAnchor),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor),
            alertView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
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
        
    }
    
    //MARK: Networking
    fileprivate func getBusinesses<S: Gettable>(fromService service: S, withSelection selection: Selection) where S.T == BusinessViewModelDataSource {
        
        service.getBusinessesFrom(selection: selection) { [weak self] (result) in
            
            guard let strongSelf = self else {
                print("SELF IS NIL IN BUSINESSFEEDVC")
                return }
            
            switch result {
            case .Success(let businessViewModelDataSource):
                strongSelf.feedDataSource = businessViewModelDataSource
                
                //setting the feedVC property of the datasource object
                strongSelf.feedDataSource.feedVC = self
                //////////////////////////////////////////////////////
                strongSelf.tableView.registerDatasource(strongSelf.feedDataSource, completion: { (complete) in
                    strongSelf.feedRefreshControl.endRefreshing()
                    strongSelf.customIndicator.stopAnimating()
                })
                
            case .Error(let error) :
                print("ERROR ON NETWORK REQUEST FROM BUSINESSFEEDVC: \(error)")
            }
        }
    }
}

//MARK: Show filter view

extension BusinessesFeedVC: FilterViewDelegate {
    
    //triggered by vc nav bar button
    @objc fileprivate func showFilterView() {
        
        filterView.selection = selection
        filterViewTopAnchor?.constant = -Constants.UI.filterViewHeight
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
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
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.8, animations: {
                self?.view.layoutIfNeeded()
            })
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







