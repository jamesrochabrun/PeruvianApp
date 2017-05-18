//
//  ListLayout.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class ListLayout: UICollectionViewFlowLayout {
    
    let innerSpace: CGFloat = 8.0
    let edgeInset: CGFloat = 5.0
    let numberOfItemsInRow: CGFloat = 3.0
    
    override init() {
        super.init()
        minimumLineSpacing = innerSpace
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func itemWidth() -> CGFloat {
        
        let totalOfInnerSpace = self.innerSpace * (self.numberOfItemsInRow - 1)
        let totalOfInset = self.edgeInset * 2
        return ((self.collectionView?.frame.size.width)! - (totalOfInset + totalOfInnerSpace)) / self.numberOfItemsInRow
    }
    
    override var itemSize: CGSize {
        set {
        }
        get {
            return CGSize(width: itemWidth(), height: itemWidth())
        }
    }
    
}


