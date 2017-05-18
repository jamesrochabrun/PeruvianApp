//
//  ImageViewBuilder.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/17/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

enum ImageViewBuilder {
    
    case imageView(radius: CGFloat?, contentMode: UIViewContentMode, clipsToBounds: Bool, userInteractionEnabled: Bool)
    case imageWithRenderMode(image: UIImage, radius: CGFloat?, contentMode: UIViewContentMode, clipsToBounds: Bool, userInteractionEnabled: Bool, tintColor: Colors)
    
    func build() -> UIImageView {
        
        switch self {
        case .imageView(let radius, let contentMode, let clipsToBounds, let userInteractionEnabled):
            return createImageViewWith(radius: radius, contentMode: contentMode, clipsToBounds: clipsToBounds, userInteractionEnabled: userInteractionEnabled)
        case .imageWithRenderMode(let image, let radius, let contentMode, let clipsToBounds, let userInteractionEnabled, let tintColor):
            return createImageViewWithRenderMode(image: image, radius: radius, contentMode: contentMode, clipsToBounds: clipsToBounds, userInteractionEnabled: userInteractionEnabled, tintColor: tintColor)
        }
    }
    
    private func createImageViewWith(radius: CGFloat?, contentMode: UIViewContentMode, clipsToBounds: Bool, userInteractionEnabled: Bool) -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = contentMode
        iv.layer.cornerRadius = radius ?? 0
        iv.clipsToBounds = clipsToBounds
        iv.isUserInteractionEnabled = userInteractionEnabled
        return iv
    }
    
    private func createImageViewWithRenderMode(image: UIImage, radius: CGFloat?, contentMode: UIViewContentMode, clipsToBounds: Bool, userInteractionEnabled: Bool, tintColor: Colors) -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = contentMode
        iv.layer.cornerRadius = radius ?? 0
        iv.clipsToBounds = clipsToBounds
        iv.isUserInteractionEnabled = userInteractionEnabled
        iv.image = #imageLiteral(resourceName: "category").withRenderingMode(.alwaysTemplate)
        iv.tintColor = tintColor.color()
        return iv
    }
}




