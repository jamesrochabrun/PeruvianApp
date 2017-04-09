//
//  BusinessFeedVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import TRON
import SwiftyJSON

class BusinessFeedVC: FeedVC {
    
    //MARK: properties
    var feedDataSource = BusinessDataSource()
    
    //MARK: APP lifecycle
    override func viewDidLoad() {

        getBusinesses(fromService: YelpService.sharedInstance)
        setUpTableView()
        setUpViews()
    }
    
    override func setUpTableView() {
        
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.insertSubview(feedRefreshControl, at: 0)
    }
    
    override func setUpNavBar() {
        super.setUpNavBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "FILTER", style: .plain, target: self, action: #selector(goToFilter))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MAP", style: .plain, target: self, action: #selector(goToMaps))
    }
    
    @objc private func goToFilter() {
        
        let filterVC = FilterVC()
        let nc = UINavigationController(rootViewController: filterVC)
        self.present(nc, animated: true)
    }
    
    @objc private func goToMaps() {
    }
    
    
    
    private func getBusinesses<S: Gettable>(fromService service: S) where S.T == BusinessDataSource {
        
        service.getBusiness(search: "Peruvian") { [unowned self] (result) in
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
                print("ERROR ON NETWORK REQUEST FROM FEEDVC: \(error)")
            }
        }
    }
}
















