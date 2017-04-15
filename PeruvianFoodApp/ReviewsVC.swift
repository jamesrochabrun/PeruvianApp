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
        setUpViews()
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name.dismissViewNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Navigation
    func dismissView() {
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
        self.tableView.register(ReviewCell.self)
    }
    
    private func getReviewsFrom(business: Business, fromService service: YelpService) {
        
        service.getReviewsFrom(businessID: business.businessID) { (result) in
            switch result {
            case .Success(let reviewsDataSource):
                self.reviewsDataSource = reviewsDataSource
                self.tableView.reloadData()
                self.customIndicator.stopAnimating()
            case .Error(let error):
                print("ERROR ON NETWORK REQUEST FROM REVIEWSVC: \(error)")
            }
        }
        
    }
}


