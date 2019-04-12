//
//  BubbleContainer.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/16/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

//MARK: protocol that will update the NearbyVC feed
protocol BubbleContainerDelegate: class {
    func updateFeed(for category: MainCategory)
}

class BubbleContainer: BaseView {
    
    //MARK: properties
    fileprivate let dataSource = BubbleContainerDataSource()
    weak var delegate: BubbleContainerDelegate?
    
    //MARK: UI elements
    lazy var photoCollectionView: UICollectionView = {
        let layout = ListLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self.dataSource
        cv.delegate = self
        cv.alwaysBounceHorizontal = true
        cv.contentInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        cv.register(BubbleCell.self)
        cv.isScrollEnabled = false
        return cv
    }()
    
    let panoramaView: GMSPanoramaView = {
        let pv = GMSPanoramaView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    //MARK: UI setup
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

//MARK: Street view logic
extension BubbleContainer {
    
    func setUpStreetView() {
        
        let panoramaService = GMSPanoramaService()
        let coordinate = CLLocationCoordinate2DMake(37.785771, -122.406165)
        panoramaService.requestPanoramaNearCoordinate(coordinate) { [weak self] (panorama, error) in
            
            DispatchQueue.main.async {
                let camera = GMSPanoramaCamera.init(heading: 180, pitch: 0, zoom: 1, fov: 90)
                self?.panoramaView.camera = camera
                self?.panoramaView.panorama = panorama
                if self?.panoramaView.panorama == nil {
                    self?.panoramaView.backgroundColor = .white
                }
            }
        }
    }
}

extension BubbleContainer: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = dataSource.getCategory(from: indexPath)
        delegate?.updateFeed(for: category)
    }
}













