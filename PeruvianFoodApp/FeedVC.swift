//
//  ViewController.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//
import UIKit
import TRON
import SwiftyJSON

class FeedVC: UITableViewController {
    
    //MARK: properties
    private var businessDataSource = BusinessDataSource()
    fileprivate var searchActive : Bool = false
    
    //MARK: UIelements
    fileprivate lazy var feedSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var feedRefreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return rf
    }()
    
    private let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    //MARK: APP lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.insertSubview(feedRefreshControl, at: 0)
        getBusinesses(fromService: YelpService.sharedInstance)
        setUpNavBar()
        setUpViews()
    }
    
    private func setUpNavBar() {
        navigationItem.titleView = feedSearchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "FILTER", style: .plain, target: self, action: #selector(goToFilter))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MAP", style: .plain, target: self, action: #selector(goToMaps))
    }
    
    @objc private func goToFilter() {}
    
    @objc private func goToMaps() {}
    
    private func setUpViews() {
        
        tableView.addSubview(customIndicator)
        customIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK: Networking
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        getBusinesses(fromService: YelpService.sharedInstance)
    }
    
    private func getBusinesses<S: Gettable>(fromService service: S) where S.T == BusinessDataSource {
        
        service.getBusiness(search: "Peruvian") { [unowned self] (result) in
            switch result {
            case .Success(let businessDataSource):
                self.businessDataSource = businessDataSource
                self.tableView.registerDatasource(self.businessDataSource, completion: { (complete) in })
                self.feedRefreshControl.endRefreshing()
                self.customIndicator.stopAnimating()
            case .Error(let error) :
                print(error)
            }
        }
    }
}





extension FeedVC: UISearchBarDelegate {
    
}





