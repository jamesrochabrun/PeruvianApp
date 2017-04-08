//
//  FilterVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/6/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class FilterVC: UITableViewController {
    
    var categoryViewModelArray: [CategoryViewModel] = [CategoryViewModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(SwitchCell.self)
        setUpNavBar()

//        Category.getCategories(for: .restaurants) { [weak self] (categoryArray) in
//            self?.categoryViewModelArray = categoryArray.map{CategoryViewModel(categorySelected: false, categoryTitle: $0.title)}
//        }
        
        
        
    }

    private func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelAndDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SEARCH", style: .plain, target: self, action: #selector(searchAndDismiss))
    }
    
    @objc private func cancelAndDismiss() {
        self.dismiss(animated: true)
    }
    
    @objc private func searchAndDismiss() {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SwitchCell
//        let categoryViewModel = categoryViewModelArray[indexPath.row]
       // cell.setUpCell(with: categoryViewModel)
     //   cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryViewModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//extension FilterVC: SwitchCellDelegate {
//    
//    func switchCell(_ cell: SwitchCell) {
//        if let indexPath = tableView.indexPath(for: cell) {
//            categoryViewModelArray[(indexPath.row)].categorySelected = cell.customSwitch.isOn
//        }
//    }
//}
//




































