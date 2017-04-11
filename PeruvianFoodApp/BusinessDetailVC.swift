//
//  BusinessDetailVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class BusinessDetailVC: UITableViewController {

    //MARK: properties
    var business: Business? {
        didSet {
            if let business = business {
                get(business: business, fromService: YelpService.sharedInstance)
            }
        }
    }
    
    var businessDetailDataSource = BusinessDetailDataSource()
    
    //MARK: App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func get(business: Business, fromService service: YelpService) {
        
        service.getBusinessFrom(id: business.businessID) { [weak self] (result) in
            switch result {
            case .Success(let business):
                self?.businessDetailDataSource.businessViewModel = BusinessViewModel(model: business, at: nil)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .Error(let error):
                print("ERROR ON BUSINESDETAILDATASOURCE: \(error)")
            }
        }
    }
    
    func setUpTableView() {
     
        tableView.register(HeaderCell.self)
        tableView.register(InfoCell.self)
        tableView.backgroundColor = .white
        tableView?.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = businessDetailDataSource
    }
    
    //MARK: Navigation
    func dismissSelf() {
        
    }
}

//MARK: Tableview
extension BusinessDetailVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else if indexPath.row == 1 {
            return tableView.rowHeight
        }
        return 10
    }
}

class BusinessDetailDataSource: NSObject, UITableViewDataSource {
    
    //MARK : Properties
    fileprivate var businessViewModel: BusinessViewModel?

    //MARK: Initializers
    override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderCell
            if let b = businessViewModel {
                cell.setUp(with: b)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InfoCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

class HeaderCell: BaseCell {
    
    let businessImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func setUpViews() {
    
        backgroundColor = .red
        addSubview(businessImageView)
        businessImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        businessImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        businessImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        businessImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        businessImageView.loadImageUsingCacheWithURLString(businessViewModel.profileImageURL, placeHolder: nil) { (complete) in
        }
    }
}

class InfoCell: BaseCell {
    
}
















