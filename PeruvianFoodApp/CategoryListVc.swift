//
//  CategoryListVc.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/7/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CategoryListVC: UITableViewController {
    
    var categoriesListViewModelArray = Array<CategoryListViewModel>() {
        didSet {
            self.tableView.reloadData()
            self.customIndicator.stopAnimating()
        }
    }
    
    //MARK: UIelements
    fileprivate lazy var categorySearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    private let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        tableView.register(ListCell.self)
        tableView.separatorStyle = .none
        setUpNavBar()
        setUpViews()
 
        getCategories { [weak self] (array) in
            self?.categoriesListViewModelArray = array
        }
    }
    
    private func setUpNavBar() {
        
        navigationItem.titleView = categorySearchBar
    }
    
    private func setUpViews() {
        
        tableView.addSubview(customIndicator)
        customIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func getCategories(completion: @escaping (_ categoryListViewModelArray: Array<CategoryListViewModel>) -> ()) {
        
        var categoriesListViewModelArray = Array<CategoryListViewModel>()
        
        for category in CategoryTitles.categoryTitlesArray {
            Category.getCategories(for: category, completion: { (categoryArray) in
                //each category separated by name 45 in total converted to a viewmodel
                let categoryViewModel = CategoryListViewModel(items: categoryArray, categoryListTitle: category.rawValue)
                categoriesListViewModelArray.append(categoryViewModel)
                if categoriesListViewModelArray.count == CategoryTitles.categoryTitlesArray.count {
                    DispatchQueue.main.async {
                        completion(categoriesListViewModelArray)
                    }
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesListViewModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListCell
        let categoryViewModel = categoriesListViewModelArray[indexPath.row]
        cell.listNameLabel.text = categoryViewModel.categoryListTitle
        return cell
    }
}



extension CategoryListVC: UISearchBarDelegate {
    
}

struct CategoryListViewModel {
    
    var items = [Category]()
    var categoryListTitle: String
}











