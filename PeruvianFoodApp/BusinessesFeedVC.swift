//
//  BusinessFeedVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import TRON
import SwiftyJSON
import MapKit

class BusinessesFeedVC: FeedVC {
    
    //MARK: properties
    var feedDataSource = BusinessDataSource()
    var selection = Selection() {
        didSet {
            getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
        }
    }
    
    //MARK: UI elements
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        sc.insertSegment(withTitle: "LIST", at: 0, animated: true)
        sc.insertSegment(withTitle: "MAP", at: 1, animated: true)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.addTarget(self, action: #selector(switchPresentation), for: .valueChanged)
        return sc
    }()
    
    //MARK: APP lifecycle
    override func viewDidLoad() {

        setUpNavBar()
        setUpTableView()
        setUpViews()
    }
        
    //MARK: FeedVC super class methods
    override func setUpTableView() {
        
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.insertSubview(feedRefreshControl, at: 0)
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        tableView.tableHeaderView = segmentedControl
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    override func setUpNavBar() {
        super.setUpNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "FILTER", style: .plain, target: self, action: #selector(goToFilter))
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
    }
    
    //MARK: segmented control trigger
    @objc private func switchPresentation() {
        
    }
    
    //MARK: navigation triggers
    @objc private func goToFilter() {
//        
//        let filterVC = FilterVC()
//        let nc = UINavigationController(rootViewController: filterVC)
//        self.present(nc, animated: true)
    }
    
    //MARK: Networking
    private func getBusinesses<S: Gettable>(fromService service: S, withSelection selection: Selection) where S.T == BusinessDataSource {
        
        service.getBusinessesFrom(selection: selection) { [unowned self] (result) in
            switch result {
            case .Success(let businessDataSource):
                self.feedDataSource = businessDataSource
                //setting the feedVC property of the datasource object
                self.feedDataSource.feedVC = self
                //////////////////////////////////////////////////////
                self.tableView.registerDatasource(self.feedDataSource, completion: { (complete) in
                    self.feedRefreshControl.endRefreshing()
                    self.customIndicator.stopAnimating()
                })
                
            case .Error(let error) :
                print("ERROR ON NETWORK REQUEST FROM BUSINESSFEEDVC: \(error)")
            }
        }
    }
}

//MARK: tableview delegate method
extension BusinessesFeedVC {
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        feedSearchBar.endEditing(true)
        let business = feedDataSource.searchActive ? feedDataSource.searchResults[indexPath.row] : feedDataSource.businesses[indexPath.row]
        let businessDetailVC = BusinessDetailVC()
        businessDetailVC.business = business
        self.present(businessDetailVC, animated: true)        
    }
}
















