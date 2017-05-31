//
//  BusinessImageDownloader.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/30/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class BusinessImageDownloader: Operation {
    
    var autoCompleteBusiness: AutoCompleteBusinessVM
    
    init(autoCompleteBusiness: AutoCompleteBusinessVM) {
        self.autoCompleteBusiness = autoCompleteBusiness
        super.init()
    }
    
    override func main() {
        //MARK : check operation was canceled
        if self.isCancelled { return }
        
        //FIX THIS LATER
//        YelpService.sharedInstance.getBusinessWithID(autoCompleteBusiness.id) { (result) in
//            
//            switch result {
//            case .Success(let business):
//                self.setUpImageDataWith(business)
//            case .Error(let error):
//                print(error)
//            }
//        }
        
        setUpImageDataWith()
    }
    
    //MARK: Helper method
    
    func setUpImageDataWith() {
        
        let i = "https://s3-media4.fl.yelpcdn.com/bphoto/--8oiPVp0AsjoWHqaY1rDQ/o.jpg"
        guard let url = URL(string: i) else {
            return
        }
        do {
            let imageData = try Data(contentsOf: url)
            
            //MARK : check operation was canceled
            if self.isCancelled { return }
            if imageData.count > 0 {
                autoCompleteBusiness.businessImage = UIImage(data: imageData)
                autoCompleteBusiness.imageState = .downloaded
            } else {
                autoCompleteBusiness.imageState = .failed
            }
        } catch let error {
            print("\(error)")
            self.cancel()
        }
    }
}






