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
            getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
        }
    }
    
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
        
        segmentedControl.selectedSegmentIndex = 0
        tableView.tableHeaderView = segmentedControl
        tableView.addSubview(alertView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35),
            alertView.heightAnchor.constraint(equalTo: view.heightAnchor),
            alertView.leftAnchor.constraint(equalTo: view.leftAnchor),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor),
            alertView.topAnchor.constraint(equalTo: view.topAnchor)
            ])
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
    private func getBusinesses<S: Gettable>(fromService service: S, withSelection selection: Selection) where S.T == BusinessViewModelDataSource {
        
        service.getBusinessesFrom(selection: selection) { [unowned self] (result) in
            switch result {
            case .Success(let businessViewModelDataSource):
                self.feedDataSource = businessViewModelDataSource
                
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







