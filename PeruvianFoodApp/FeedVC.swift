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
    
    var businesses: [Business] = [Business]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        
        YelpService.sharedInstance.getBusiness(search: "Peruvian") { (result) in
            switch result {
            case .Success(let businessDataSource) :
                self.businesses = businessDataSource.business
            case .Error(let error) :
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BusinesCell
        let business = businesses[indexPath.item]
        let businessViewModel = BusinessCellViewModel(model: business, at: indexPath.item)
        cell.businessCellViewModel = businessViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}








