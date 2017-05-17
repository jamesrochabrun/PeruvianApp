//
//  BubbleContainerDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/16/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class BubbleContainerDataSource: NSObject, UICollectionViewDataSource {
    
    fileprivate let bubbleCategories: [MainCategory] = [.restaurants, .bars, .food]
    
    override init() {
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bubbleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as BubbleCell
        let category = getCategory(from: indexPath)
        cell.setUpCell(category)
        return cell
    }
}

//MARK: Helper Methods
extension BubbleContainerDataSource {
    
    func getCategory(from indexPath: IndexPath) -> MainCategory {
        return bubbleCategories[indexPath.item]
    }
}



