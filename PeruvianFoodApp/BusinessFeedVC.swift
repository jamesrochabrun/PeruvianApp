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
    var selection: Selection? {
        didSet {
            if let selection = selection {
                getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
                print(selection)
            }
        }
    }
    
    //MARK: APP lifecycle
    override func viewDidLoad() {

        setUpNavBar()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "FILTER", style: .plain, target: self, action: #selector(goToFilter))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MAP", style: .plain, target: self, action: #selector(goToMaps))
    }
    
    @objc private func goToFilter() {
//        
//        let filterVC = FilterVC()
//        let nc = UINavigationController(rootViewController: filterVC)
//        self.present(nc, animated: true)
    }
    
    @objc private func goToMaps() {
    }
    
    
    private func getBusinesses<S: Gettable>(fromService service: S, withSelection selection: Selection) where S.T == BusinessDataSource {
        
        service.getBusinessFrom(selection: selection) { (result) in
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
















