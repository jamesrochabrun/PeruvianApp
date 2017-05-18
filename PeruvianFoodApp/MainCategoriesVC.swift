//
//  CategoryFeedVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class MainCategoriesVC: UIViewController {
    
    //MARK: Properties
    let dataSource = MainCategoriesDataSource(categoriesViewModelArray: [])
    var mainCategoryViewModel = MainCategoryViewModel()
    
    //MARK: UI
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.estimatedRowHeight = 100
        tv.rowHeight = UITableViewAutomaticDimension
        tv.separatorStyle = .none
        tv.register(CategoryCell.self)
        tv.dataSource = self.dataSource
        tv.bounces = false
        return tv
    }()
    
    //MARK: APP lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadCategories()
        self.title = "Categories"
    }
    
    func loadCategories() {
        
        mainCategoryViewModel.getMainCategories { [weak self] (mainCategoriesArray) in
            self?.dataSource.update(with: mainCategoriesArray)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    
    //MARK: Set up UI
    private func setUpViews() {
        view.addSubview(tableView)
    }
}

//MARK: tableview delegate
extension MainCategoriesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainCategoryViewModel = dataSource.getMainCategoryViewModelFrom(indexPath)
        let subCategoriesVC = SubCategoriesVC()
        subCategoriesVC.mainCategoryViewModel = mainCategoryViewModel
        self.navigationController?.pushViewController(subCategoriesVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.size.height - 64) / 3
    }
}










