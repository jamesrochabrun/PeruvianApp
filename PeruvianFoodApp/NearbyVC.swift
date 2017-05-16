//
//  NearbyVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.

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
        bubbleContainer.setUpStreetViewWith(nil)
    }
    
    override func setUpNavBar() {
        navigationItem.titleView = feedSearchBar
    }
    
    override func setUpTableView() {
        view.addSubview(tableView)
        tableView.register(BusinesCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    override func viewWillLayoutSubviews() {
        
        NSLayoutConstraint.activate([
            
            bubbleContainer.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            bubbleContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            bubbleContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            bubbleContainer.heightAnchor.constraint(equalToConstant: view.frame.size.width / 3),
            
            tableView.bottomAnchor.constraint(equalTo: (tabBarController?.tabBar.topAnchor)!),
            tableView.topAnchor.constraint(equalTo: bubbleContainer.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            customIndicator.heightAnchor.constraint(equalToConstant: 80),
            customIndicator.widthAnchor.constraint(equalToConstant: 80),
            customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    override func setUpViews() {
        view.addSubview(bubbleContainer)
        tableView.addSubview(customIndicator)
    }
}

import GoogleMaps

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
    
    let panoramaView: GMSPanoramaView = {
        let pv = GMSPanoramaView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    override func setUpViews() {
        
        addSubview(panoramaView)
        addSubview(photoCollectionView)

        NSLayoutConstraint.activate([
            panoramaView.bottomAnchor.constraint(equalTo: bottomAnchor),
            panoramaView.widthAnchor.constraint(equalTo: widthAnchor),
            panoramaView.topAnchor.constraint(equalTo: topAnchor),
            panoramaView.leftAnchor.constraint(equalTo: leftAnchor),
            
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}


extension BubbleContainer {
    
    fileprivate func setUpStreetViewWith(_ viewModel: BusinessViewModel?) {
        
        let panoramaService = GMSPanoramaService()
        let coordinate = CLLocationCoordinate2DMake(37.785771, -122.406165)
        panoramaService.requestPanoramaNearCoordinate(coordinate) { [weak self] (panorama, error) in
            
            let camera = GMSPanoramaCamera.init(heading: 180, pitch: 0, zoom: 1, fov: 90)
            self?.panoramaView.camera = camera
            self?.panoramaView.panorama = panorama
            if self?.panoramaView.panorama == nil {
              //  self?.alertUserIfPanoramaIsNil()
            }
        }
    }
    
//    private func alertUserIfPanoramaIsNil() {
//        
//        DispatchQueue.main.async { [weak self] in
//            let alertController = UIAlertController(title: "No data Available", message: "Sorry, Google can't show data for this point.", preferredStyle: .alert)
//            let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
//                alertController.dismiss(animated: true)
//            }
//            alertController.addAction(dismissAction)
//            self?.present(alertController, animated: true)
//        }
//    }
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



































