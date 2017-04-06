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

protocol FeedVCDelegate: class {
    func updateDataInVC(_ vc: FeedVC)
}

class FeedVC: UITableViewController {
    
    //MARK: properties
    fileprivate var businessDataSource = BusinessDataSource()
    var searchActive : Bool = false
    fileprivate var searchResults: [Business] = []
    weak var delegate: FeedVCDelegate?
    
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
                self.businessDataSource.feedVC = self
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
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        feedSearchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.endEditing(true)
        delegate?.updateDataInVC(self)
        reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true;
        self.filterContentFor(textToSearch: searchText)
        
        if searchText != "" {
            searchActive = true
        } else {
            searchActive = false
        }
        delegate?.updateDataInVC(self)
        reloadData()
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.businessDataSource.searchResults = self.businessDataSource.businesses.filter({ (business) -> Bool in
            let businessNameToFind = business.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            //let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            //let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return (businessNameToFind != nil) //|| (typeToFind != nil) || (locationToFind != nil)
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        feedSearchBar.endEditing(true)
    }
}













