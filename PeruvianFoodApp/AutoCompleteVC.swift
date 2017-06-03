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
    let locationManager = LocationManager()
    let selection = Selection()
   
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
        locationManager.delegate = self
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        resetSelectionStatus()
    }
    
    //MARK: helper method to reset state of categories for new results on next VC
    func resetSelectionStatus() {
        selection.categoryItems.removeAll()
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
        
        guard let autoCompleteResponse = dataSource.getAutoCompleteResponse() else {
            print("autocompleteresponse is nil on selection")
            return
        }
        
        switch indexPath.section {
        case 0:
            openBusinessDetailVCwith(autoCompleteResponse.businesses[indexPath.row].id)
        case 1:
            selection.term = autoCompleteResponse.terms[indexPath.row].text
            showBusinessesBasedOnTermOrCategory()
        case 2:
            let categoryAlias = autoCompleteResponse.categories[indexPath.row].alias
            selection.categoryItems.append(categoryAlias)
            showBusinessesBasedOnTermOrCategory()
        default:
            break
        }
    }
    
    //MARK: helper methods
    func openBusinessDetailVCwith(_ businessID: String) {
        
        let businesesVC = BusinessDetailVC()
        businesesVC.businessID = businessID
        businesesVC.hidesBottomBarWhenPushed = true
        self.present(businesesVC, animated: true)
    }
    
    func showBusinessesBasedOnTermOrCategory() {

        let businesesVC = NearbyBusinessesVC()
        businesesVC.selection = selection
        businesesVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(businesesVC, animated: true)
    }
}


//MARK: Search updates protocol "delegate" gets triggered every time
extension AutoCompleteVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let textToSearch = searchController.searchBar.text else { return }
        
        textToSearch.characters.count == 0 ? updateDataIfTextIsBlank() : updateSelectionWith(text: textToSearch)
//        if textToSearch.characters.count == 0 {
//            updateDataIfTextIsBlank()
//        } else {
//            updateSelectionWith(term: textToSearch)
//        }
    }
    
    //MARK: helper methods
    func updateDataIfTextIsBlank() {

        self.dataSource.update(with: nil)
        self.businessesTableView.reloadData()
    }
    
    func updateSelectionWith(text: String) {
        
        selection.text = text
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

//MARK: LocationManagerDelegate delegate methods
extension AutoCompleteVC: LocationManagerDelegate {
    
    func displayInVC(_ alertController: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    func getCoordinates(_ coordinates: Coordinates) {
        selection.coordinates = coordinates
        
        print("Coordinates", coordinates)
        
        //START FROM HERE
    }
}













