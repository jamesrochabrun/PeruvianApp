//
//  FoodieCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class FoodiePhotoCell: BaseCell {
    
    //MARK: UI Elements
    let foodieImageview = ImageViewBuilder.imageView(radius: nil, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
    
    let dividerLine: BaseView = {
        let v = BaseView()
        v.backgroundColor = Colors.white.color()
        return v
    }()
    
    //MARK: Setup UI
    override func setUpViews() {
        addSubview(foodieImageview)
        addSubview(dividerLine)
        NSLayoutConstraint.activate([
            
            foodieImageview.topAnchor.constraint(equalTo: topAnchor),
            foodieImageview.leftAnchor.constraint(equalTo: leftAnchor),
            foodieImageview.rightAnchor.constraint(equalTo: rightAnchor),
            foodieImageview.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerLine.leftAnchor.constraint(equalTo: leftAnchor),
            dividerLine.rightAnchor.constraint(equalTo: rightAnchor),
            dividerLine.heightAnchor.constraint(equalToConstant: 2.0)
            ])
    }
    
    //MARK: helper method for setup cell data
    func setUpCell(with photo: Photo) {
        
        DispatchQueue.main.async { [weak self] in
            if let photoData = photo.image as? Data {
                self?.foodieImageview.image = UIImage(data: photoData)
            }
        }
    }
}
