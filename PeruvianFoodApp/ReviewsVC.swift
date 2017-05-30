//
//  ReviewsVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class ReviewsVC: UITableViewController {
    
    //MARK: Properties
    fileprivate var reviewsDataSource = ReviewsViewModelDataSource()
    
    var businessViewModel: BusinessViewModel? {
        didSet {
            if let businessViewModel = businessViewModel {
                getReviewsFrom(business: businessViewModel, fromService: YelpService.sharedInstance)
            }
        }
    }
    
    //MARK: UI elements
    private let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    let alertView: AlertView = {
        let av = AlertView(message: "No Reviews", image: #imageLiteral(resourceName: "Jelly"))
        av.alpha = 0
        return av
    }()
    
    //MARK: App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpViews()
        setUpTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            customIndicator.heightAnchor.constraint(equalToConstant: 80),
            customIndicator.widthAnchor.constraint(equalToConstant: 80),
            customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.heightAnchor.constraint(equalTo: view.heightAnchor),
            alertView.leftAnchor.constraint(equalTo: view.leftAnchor),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor),
            alertView.topAnchor.constraint(equalTo: view.topAnchor)
            ])
    }
    
    //MARK: Navigation
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    //MARK: Set UP UI
    private func setUpNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissView))
    }
    
    func setUpViews() {
        view.addSubview(customIndicator)
        tableView.addSubview(alertView)
    }
    
    func setUpTableView() {
        tableView.register(ReviewCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func getReviewsFrom(business: BusinessViewModel, fromService service: YelpService) {
        
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


