//
//  ReviewsVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class ReviewsVC: UITableViewController {
    
    var reviewsDataSource = ReviewsDataSource()
    
    var business: Business? {
        didSet {
            if let business = business {
                getReviewsFrom(business: business, fromService: YelpService.sharedInstance)
            }
        }
    }
    
    //MARK: UI elements
    private let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpViews()
        setUpTableView()
    }
    
    private func setUpNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissView))
    }
    
    //MARK: Navigation
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            customIndicator.heightAnchor.constraint(equalToConstant: 80),
            customIndicator.widthAnchor.constraint(equalToConstant: 80),
            customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    func setUpViews() {
        view.addSubview(customIndicator)
    }
    
    func setUpTableView() {
        tableView.register(ReviewCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func getReviewsFrom(business: Business, fromService service: YelpService) {
        
        service.getReviewsFrom(businessID: business.businessID) { (result) in
            switch result {
            case .Success(let reviewsDataSource):
                self.reviewsDataSource = reviewsDataSource
                self.tableView.registerDatasource(self.reviewsDataSource, completion: { (complete) in
                    self.tableView.reloadData()
                    self.customIndicator.stopAnimating()
                })     
            case .Error(let error):
                print("ERROR ON NETWORK REQUEST FROM REVIEWSVC: \(error)")
            }
        }
    }
}


