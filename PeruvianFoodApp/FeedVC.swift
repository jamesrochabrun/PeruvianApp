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
    func filterContentFor(textToSearch: String)
}

class FeedVC: UITableViewController {
    
    //MARK: properties
    var searchActive: Bool = false
    weak var delegate: FeedVCDelegate?
    
    //MARK: UIElements
    //Search Bar
    lazy var feedSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    //Refresh Control
    lazy var feedRefreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return rf
    }()
    
    //Loading Indicator
    let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    //MARK: APP lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
        setUpTableView()
        setUpViews()
    }
    
    func setUpNavBar() {
        
        navigationItem.titleView = feedSearchBar
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "FILTER", style: .plain, target: self, action: #selector(goToFilter))
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MAP", style: .plain, target: self, action: #selector(goToMaps))
    }
    
    func setUpTableView() {
        
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.insertSubview(feedRefreshControl, at: 0)
    }
    
    func setUpViews() {
        
        tableView.addSubview(customIndicator)
        customIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
  //  MARK: Networking
    func refresh(_ refreshControl: UIRefreshControl) {
    }
}

//Reusable searchBar actions
extension FeedVC: UISearchBarDelegate {
    
    func reloadData() {
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
        
        searchActive = true
        delegate?.filterContentFor(textToSearch: searchText)
        searchActive = searchText != "" ? true : false
        delegate?.updateDataInVC(self)
        reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        feedSearchBar.endEditing(true)
    }
}














