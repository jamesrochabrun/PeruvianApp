//
//  PendingOperations.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

class PendingOperations {
    
    var downloadsInProgress = [IndexPath: Operation]()
    let downloadQueue = OperationQueue()
}
