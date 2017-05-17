//
//  NearbyVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.

import Foundation
import UIKit

class NearbyVC: BusinessesFeedVC {
    
    //MARK: private properties
    fileprivate let nearbySelection = Selection()

    //MARK: UI elements
    lazy var bubbleContainer: BubbleContainer = {
        let b = BubbleContainer()
        b.delegate = self
        return b
    }()
    
    //MARK: App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleContainer.setUpStreetView()
        super.getBusinesses(fromService: YelpService.sharedInstance, withSelection: nearbySelection)
    }
    
    override func viewWillLayoutSubviews() {
        
        NSLayoutConstraint.activate([
            
            bubbleContainer.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            bubbleContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            bubbleContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            bubbleContainer.heightAnchor.constraint(equalToConstant: Constants.UI.bubbleContainerHeight),
            
            tableView.bottomAnchor.constraint(equalTo: (tabBarController?.tabBar.topAnchor)!),
            tableView.topAnchor.constraint(equalTo: bubbleContainer.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            customIndicator.heightAnchor.constraint(equalToConstant: Constants.UI.customIndicatorDefault),
            customIndicator.widthAnchor.constraint(equalToConstant: Constants.UI.customIndicatorDefault),
            customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    //MARK: Set Up UI
    override func setUpNavBar() {
        
        navigationItem.titleView = feedSearchBar
    }
    
    override func setUpViews() {
        
        view.addSubview(bubbleContainer)
        view.addSubview(customIndicator)
    }
    
    override func setUpTableView() {
        
        view.addSubview(tableView)
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

//MARK: delegate method of BubbleContainer
extension NearbyVC: BubbleContainerDelegate {
    
    func updateFeed(for category: MainCategory) {
        nearbySelection.mainCategory = category
        super.getBusinesses(fromService: YelpService.sharedInstance, withSelection: nearbySelection)
    }
}



































