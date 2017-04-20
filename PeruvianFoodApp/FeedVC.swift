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

class FeedVC: UIViewController, UITableViewDelegate {
    
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
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        return tv
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
    
    //call this method if customindicator is needed
    func setUpTableView() {
        
        view.addSubview(tableView)
        tableView.addSubview(customIndicator)
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            customIndicator.heightAnchor.constraint(equalToConstant: 80),
            customIndicator.widthAnchor.constraint(equalToConstant: 80),
            customIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
            ])
    }
    
    func setUpViews() {
    }
    
    //MARK: Scrollview draggin 
    func scrollViewIsDragging() {
        feedSearchBar.endEditing(true)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewIsDragging()
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














