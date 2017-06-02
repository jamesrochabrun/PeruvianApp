//
//  BusinessDetailDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol BusinessDetailDataSourceDelegate: class {
    func reloadDataInVC()
    func alertUserOfError()
}

class BusinessDetailDataSource: NSObject, UITableViewDataSource {
    
    //MARK : Properties
    weak var delegate: BusinessDetailDataSourceDelegate?
    
    //MARK: 2 main sources of data visual model setted in the networking call
    fileprivate var businessViewModel: BusinessViewModel?
    //this is for the rocket icon
    
    //MARK: Initializers
    override init() {
        super.init()
    }
    
    //MARK: init from businessesVC
    convenience init(businessViewModel: BusinessViewModel) {
        self.init()
        getBusinessFrom(businessViewModel, fromService: YelpService.sharedInstance)
    }
    
    //MARK: init from searchVC 
    //NOTE: needs to be simplified once I decide how to handle location in multiple VC's
    convenience init(businessID: String) {
        self.init()
        YelpService.sharedInstance.getBusinessWithID(businessID) { [weak self] (result) in
            switch result {
            case .Success(let business):
                self?.businessViewModel = BusinessViewModel(model: business)
               // self?.businessViewModel?.distance = businessViewModel.distance
                self?.delegate?.reloadDataInVC()
            case .Error(let error):
                print("ERROR ON BUSINES DETAIL DATASOURCE: \(error)")
                self?.delegate?.alertUserOfError()
            }
        }
    }
    
    //MARK: Networking
    func getBusinessFrom(_ businessViewModel: BusinessViewModel, fromService service: YelpService) {
      
        let id = businessViewModel.businessID //"ZJchvgEX6Pzy33DWpSRL6A" KFC test
        service.getBusinessWithID(id) { [weak self] (result) in
            switch result {
            case .Success(let business):
                self?.businessViewModel = BusinessViewModel(model: business)
                self?.businessViewModel?.distance = businessViewModel.distance
                self?.delegate?.reloadDataInVC()
            case .Error(let error):
                print("ERROR ON BUSINES DETAIL DATASOURCE: \(error)")
                self?.delegate?.alertUserOfError()
            }
        }
    }
    
    //MARK: TableView DataSource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let businessViewModel = businessViewModel else {
            return BaseCell()
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderCell
            cell.setUp(with: businessViewModel)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InfoCell
            cell.setUp(with: businessViewModel)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SubInfoCell
            cell.setUp(with: businessViewModel)
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MapCell
            cell.setUpGoogleMapWith(businessViewModel)
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HoursCell
            cell.setUp(with: businessViewModel)
            return cell
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PhotoAlbumCell
        cell.photos = businessViewModel.photos 
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}







