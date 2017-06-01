//
//  TermBusinessesVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/29/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class AutoCompleteVC: UIViewController {
    
    //MARK: UI Properties
    let searchController = UISearchController(searchResultsController: nil)
    let dataSource = AutoCompleteResponseDataSource()
    var businessTableViewBottomAnchor: NSLayoutConstraint?
   
    lazy var businessesTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.dataSource = self.dataSource
        tv.register(AutoCompleteBusinessCell.self)
        tv.register(ReusableHeaderCell.self)
        tv.register(AutoCompleteBusinessCellText.self)
        tv.register(UITableViewCell.self)
        
        tv.tableHeaderView = self.searchController.searchBar
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 100
        return tv
    }()
    
    //MARK: app Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func setUpViews() {
        
        view.backgroundColor = .white
        view.addSubview(businessesTableView)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        //this hides the searchbar in the next vc
        definesPresentationContext = true
        
        businessTableViewBottomAnchor = businessesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        businessTableViewBottomAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            businessesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            businessesTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            businessesTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
    }
}

//MARK: tableview delegate methods
extension AutoCompleteVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let reusableHeaderCell = tableView.dequeueReusableCell() as ReusableHeaderCell
        if let title = dataSource.getAutoCompleteResponse()?.titles[section] {
            reusableHeaderCell.setUpWith(text: title)
        }
        return reusableHeaderCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.UI.reusableHeaderCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let something = dataSource.getAutoCompleteResponse()?.content[indexPath.section][indexPath.row]
        print("Something: \(something)")
    }
}


//MARK: Search updates protocol "delegate" gets triggered every time
extension AutoCompleteVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let textToSearch = searchController.searchBar.text else { return }
        
        if textToSearch.characters.count == 0 {
            updateDataIfTextIsBlank()
            
        } else {
            updateSelectionWith(term: textToSearch)
        }
    }
    
    //MARK: helper methods
    func updateDataIfTextIsBlank() {

        self.dataSource.update(with: nil)
        self.businessesTableView.reloadData()
    }
    
    func updateSelectionWith(term: String) {
        
        let selection = Selection()
        selection.term = term
        
        YelpService.sharedInstance.getAutoCompleteResponseFrom(selection: selection) { (result) in
          
            switch result {
            case .Success(let response):
                self.dataSource.update(with: response)
                self.businessesTableView.reloadData()
            case .Error(let error):
                print("\(error)")
            }
        }
    }
}

//MARK: Handle keyboard show and hide
extension AutoCompleteVC {
    
    func handleKeyboardWillShow(notification: NSNotification) {
        
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        if let keyboardFrame = keyboardFrame {
            businessTableViewBottomAnchor?.constant = -keyboardFrame.height
        }
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        if let keyboardDuration = keyboardDuration {
            UIView.animate(withDuration: keyboardDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
        
        businessTableViewBottomAnchor?.constant = 0
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        if let keyboardDuration = keyboardDuration {
            UIView.animate(withDuration: keyboardDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}















