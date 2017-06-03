//
//  PhotoAlbumCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


class PhotoAlbumCell: BaseCell, UICollectionViewDelegate {
    
    //MARK: dataSource
    var photos: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    //MARK: UI Elements
    lazy var photoCollectionView: UICollectionView = {
        let layout = ListLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.alwaysBounceHorizontal = true
        cv.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        cv.register(PhotoCell.self)
        cv.isScrollEnabled = false
        return cv
    }()
    
    //MARK: Set Up UI
    override func setUpViews() {
        
        addSubview(photoCollectionView)
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
    
    }
}

//MARK: UICollectionViewDataSource methods
extension PhotoAlbumCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = photos?.count {
            print("count", count)
            return count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PhotoCell
        if let photoURL = photos?[indexPath.row] {
            cell.setUp(photoURL: photoURL)
        }
        return cell
    }
}





