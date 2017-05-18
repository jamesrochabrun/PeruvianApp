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
    fileprivate let dataSource = SubCategoriesDataSource()
    
    //MARK: App Lyfecycle
    override func viewDidLoad() {
        
        setUpNavBar()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK: FeedVC super class methods
    //overriding method to avoid customindicator
    override func setUpTableView() {
        super.setUpTableView()

        tableView.register(SwitchCell.self)
        tableView.registerDatasource(dataSource, completion: { (complete) in })
    }

    override func setUpNavBar() {
        super.setUpNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SEARCH", style: .plain, target: self, action: #selector(searchAndOpenResults))
    }
    
    //MARK: navigation triggers
    func searchAndOpenResults() {
        
        feedSearchBar.endEditing(true)
        let businesesVC = BusinessesVC()
        businesesVC.selection = dataSource.getSelection()
        self.navigationController?.pushViewController(businesesVC, animated: true)
    }
}

//MARK: tableview delegate methods
extension SubCategoriesVC {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}






























