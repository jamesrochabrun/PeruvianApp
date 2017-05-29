//
//  FilterVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/6/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class SubCategoriesVC: SearchVC {
    
    //MARK: Properties
    var mainCategoryViewModel: MainCategoryViewModel? {
        didSet {            
            if let mainCategoryViewModel = mainCategoryViewModel {
                self.dataSource.updateWith(mainCategoryViewModel)
                self.dataSource.subCategoriesVC = self
                self.title = mainCategoryViewModel.mainCategory.rawValue
            }
        }
    }
    let locationManager = LocationManager()
    
    fileprivate let dataSource = SubCategoriesDataSource()
    
    //MARK: App Lyfecycle
    override func viewDidLoad() {
        
        setUpNavBar()
        setUpTableView()
        locationManager.delegate = self
    }
    
    //MARK: FeedVC super class methods
    //overriding method to avoid customindicator
    override func setUpTableView() {
        super.setUpTableView()

        tableView.register(SwitchCell.self)
        tableView.registerDatasource(dataSource, completion: { (complete) in })
    }

    override func setUpNavBar() {
        //super.setUpNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SEARCH", style: .plain, target: self, action: #selector(searchAndOpenResults))
    }
    
    //MARK: navigation triggers
    func searchAndOpenResults() {
        
        feedSearchBar.endEditing(true)
        let businesesVC = BusinessesVC()
        businesesVC.selection = dataSource.getSelection()
        businesesVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(businesesVC, animated: true)
    }
}

//MARK: tableview delegate methods
extension SubCategoriesVC {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: LocationManagerDelegate delegate methods
extension SubCategoriesVC: LocationManagerDelegate {
    
    func displayInVC(_ alertController: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    func getCoordinates(_ coordinates: Coordinates) {
        dataSource.updateSelectionWith(coordinates)
    }
}






























