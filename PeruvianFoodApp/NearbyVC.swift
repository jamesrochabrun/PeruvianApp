//
//  NearbyVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class NearbyVC: BusinessesFeedVC {
    
    let bubbleContainer: BubbleContainer = {
        let b = BubbleContainer()
        return b
    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        let selection = Selection()
        selection.categoryParent = "restaurants"
        super.getBusinesses(fromService: YelpService.sharedInstance, withSelection: selection)
    }
    
    override func setUpNavBar() {
        navigationItem.titleView = feedSearchBar
    }
    
    override func setUpTableView() {
        view.addSubview(tableView)
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
    
    override func viewWillLayoutSubviews() {
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: bubbleContainer.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            customIndicator.heightAnchor.constraint(equalToConstant: 80),
            customIndicator.widthAnchor.constraint(equalToConstant: 80),
            customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bubbleContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            bubbleContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            bubbleContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            bubbleContainer.heightAnchor.constraint(equalToConstant: view.frame.size.width / 3)
            ])
    }
    
    override func setUpViews() {
        
        view.addSubview(customIndicator)
        view.addSubview(bubbleContainer)

    }
}




class BubbleContainer: BaseView {
    
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

extension BubbleContainer: UICollectionViewDataSource, UICollectionViewDelegate {
    
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



































