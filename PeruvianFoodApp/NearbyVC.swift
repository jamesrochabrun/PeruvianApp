//
//  NearbyVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class NearbyVC: FeedVC {
    
    //MARK: properties
    var dataSource = NearbyVCDataSource()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        tableView.registerDatasource(dataSource) { (_) in
        }
    }
    
    override func setUpTableView() {
        view.addSubview(tableView)
        tableView.register(BubbleContainerCell.self)
        tableView.register(UITableViewCell.self) //remove
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
    override func setUpViews() {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return view.frame.width / 3
        } else {
            return UITableViewAutomaticDimension
        }
    }
}




class NearbyVCDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var businessesViewModel: [BusinessViewModel] = [BusinessViewModel]()
    fileprivate var searchResults: [BusinessViewModel] = [BusinessViewModel]()
    fileprivate var searchActive : Bool = false

    override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BubbleContainerCell
            return cell
        } 
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as UITableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return searchActive ? searchResults.count : businessesViewModel.count
        }
    }
}









class BubbleContainerCell: BaseCell {
    
    fileprivate let bubbleCategories = ["Restaurants", "Bars", "Food"]
    
    lazy var photoCollectionView: UICollectionView = {
        let layout = ListLayout()        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceHorizontal = true
        cv.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        cv.register(BubbleCell.self)
        cv.isScrollEnabled = false
        return cv
    }()
    
    override func setUpViews() {
        
        addSubview(photoCollectionView)
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}

extension BubbleContainerCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bubbleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as BubbleCell
        cell.setUpCell(bubbleCategories[indexPath.item])
        return cell
    }
}

class BubbleCell: BaseCollectionViewCell {
    
    
    let categoryImageview: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 45
        iv.clipsToBounds = true
        iv.backgroundColor = .purple
        return iv
    }()
    
    let categoryLabel = LabelBuilder.headerLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    override func setupViews() {
        
        addSubview(categoryImageview)
        addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            
            categoryImageview.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryImageview.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryImageview.widthAnchor.constraint(equalToConstant: 90),
            categoryImageview.heightAnchor.constraint(equalToConstant: 90),
            
            categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    func setUpCell(_ category: String) {
        categoryLabel.text = category
    }
}



































