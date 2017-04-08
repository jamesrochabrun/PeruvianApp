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

protocol FeedVCDelegate: class {
    func updateDataInVC(_ vc: FeedVC)
    func filterContentFor(textToSearch: String)
}

class FeedVC: UITableViewController {
    
    //MARK: properties
    var feedDataSource = BusinessDataSource()

    var searchActive : Bool = false
    weak var delegate: FeedVCDelegate?
    
    //MARK: UIelements
    lazy var feedSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var feedRefreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return rf
    }()
    
    let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    //MARK: APP lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.insertSubview(feedRefreshControl, at: 0)
        getBusinesses(fromService: YelpService.sharedInstance)
        setUpNavBar()
        setUpViews()
    }
    
    func setUpNavBar() {
        
        navigationItem.titleView = feedSearchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "FILTER", style: .plain, target: self, action: #selector(goToFilter))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MAP", style: .plain, target: self, action: #selector(goToMaps))
    }
    
    @objc private func goToFilter() {
        
        let filterVC = FilterVC()
        let nc = UINavigationController(rootViewController: filterVC)
        self.present(nc, animated: true)
    }
    
    @objc private func goToMaps() {}
    
    func setUpViews() {
        
        tableView.addSubview(customIndicator)
        customIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK: Networking
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        
        getBusinesses(fromService: YelpService.sharedInstance)
    }
    
    private func getBusinesses<S: Gettable>(fromService service: S) where S.T == BusinessDataSource {
        
        service.getBusiness(search: "Peruvian") { [unowned self] (result) in
            switch result {
            case .Success(let businessDataSource):
                self.feedDataSource = businessDataSource
                //setting the feedVC property of the datasource object
                self.feedDataSource.feedVC = self
                //////////////////////////////////////////////////////
                self.tableView.registerDatasource(self.feedDataSource, completion: { (complete) in
                    self.feedRefreshControl.endRefreshing()
                    self.customIndicator.stopAnimating()
                })
      
            case .Error(let error) :
                print("ERROR ON NETWORK REQUEST FROM FEEDVC: \(error)")
            }
        }
    }
}

extension FeedVC: UISearchBarDelegate {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        feedSearchBar.endEditing(true)
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
        feedSearchBar.endEditing(true)
    }
}


class CategoryFeedVC: FeedVC {

    var categoryDataSource = CategoryDataSource()
    
    override func viewDidLoad() {
        tableView.register(ListCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = categoryDataSource
        self.categoryDataSource.categoryFeedVC = self
        setUpNavBar()
        setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataInVC), name: NSNotification.Name(rawValue: "name"), object: nil)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "name"), object: nil);
    }
    
    func reloadDataInVC() {
        tableView.reloadData()
        customIndicator.stopAnimating()
    }
    
    override func setUpNavBar() {
        navigationItem.titleView = feedSearchBar
    }
}

class CategoryDataSource: NSObject, UITableViewDataSource {
    
    var categoriesViewModelArray = [CategoryViewModel]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "name"), object: nil)
        }
    }
    var searchResults = [CategoryViewModel]()
    var searchActive : Bool = false
    var categoryFeedVC: CategoryFeedVC?
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        
        let categoryViewModel = CategoryViewModel()
        categoryViewModel.getAllCategoriesAsViewModel { (array) in
            self.categoriesViewModelArray = array
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.categoryFeedVC?.delegate = self
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListCell
        cell.listNameLabel.text = searchActive ? searchResults[indexPath.row].categoryListTitle : categoriesViewModelArray[indexPath.row].categoryListTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? searchResults.count : categoriesViewModelArray.count
    }
}


extension CategoryDataSource: FeedVCDelegate {
    
    //THIS NEEDS RESEARCH FROM HERE 
    func updateDataInVC(_ vc: FeedVC) {
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













