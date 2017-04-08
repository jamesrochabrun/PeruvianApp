//
//  CategoryListVc.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/7/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryListVCDelegate: class {
    func updateDataInVC(_ vc: CategoryListVC)
    func filterContentFor(textToSearch: String)
}

class CategoryListVC: UITableViewController {
    
    //MARK: properties
    fileprivate var categoryListDataSource = CategoryListDataSource()
    weak var delegate: CategoryListVCDelegate?
    var searchActive : Bool = false
    
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
       // categoryListDataSource.categoryListVC = self
        tableView.registerDatasource(categoryListDataSource) { (complete) in
            self.customIndicator.stopAnimating()
        }
        setUpNavBar()
        setUpViews()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}



extension CategoryListVC: UISearchBarDelegate {
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        categorySearchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = true
        searchBar.endEditing(true)
        delegate?.updateDataInVC(self)
        reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchActive = true
        delegate?.filterContentFor(textToSearch: searchText)
        searchActive = searchText != "" ? true : false
        delegate?.updateDataInVC(self)
        reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        categorySearchBar.endEditing(true)
    }
}

class CategoryListDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var categoriesViewModelArray = [CategoryViewModel]() {
        didSet{
            print(categoriesViewModelArray.count)
        }
    }
    
    var searchResults = [CategoryViewModel]()
    var searchActive : Bool = false
    var categoryListVC: CategoryListVC?
    
    override init() {
        super.init()
        loaddata()
    }
    
    private func loaddata() {
        let categoryViewModel = CategoryViewModel()
        categoryViewModel.getAllCategoriesAsViewModel { (array) in
            self.categoriesViewModelArray = array
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.categoryListVC?.delegate = self
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListCell
        cell.listNameLabel.text = categoriesViewModelArray[indexPath.row].categoryListTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesViewModelArray.count
    }
}


extension CategoryListDataSource: CategoryListVCDelegate {
    
    func updateDataInVC(_ vc: CategoryListVC) {
        searchActive = vc.searchActive
    }

    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.categoriesViewModelArray.filter({ (category) -> Bool in
            let categoryNameToFind = category.categoryListTitle?.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            //let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            //let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return (categoryNameToFind != nil) //|| (typeToFind != nil) || (locationToFind != nil)
        })
    }
}

























