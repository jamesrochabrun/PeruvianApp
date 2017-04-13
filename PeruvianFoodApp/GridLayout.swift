//
//  GridLayout.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    let innerSpace: CGFloat = 1.0
    let numberOfItemsInRow: CGFloat = 4.0
    
    override init() {
        super.init()
        minimumLineSpacing = innerSpace
        minimumInteritemSpacing = innerSpace
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func itemWidth() -> CGFloat {
        return ((self.collectionView?.frame.size.width)! / self.numberOfItemsInRow) - self.innerSpace
    }
    
    override var itemSize: CGSize {
        set {
        }
        get {
            return CGSize(width: itemWidth(), height: itemWidth())
        }
    }
}
