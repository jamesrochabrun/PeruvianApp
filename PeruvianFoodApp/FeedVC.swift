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
    
    private var businessDataSource = BusinessDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        
        YelpService.sharedInstance.getBusiness(search: "Peruvian") { [unowned self] (result) in
            switch result {
            case .Success(let businessDataSource):
                self.businessDataSource = businessDataSource
                self.tableView.registerDatasource(self.businessDataSource, completion: { (complete) in })
            case .Error(let error) :
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}






