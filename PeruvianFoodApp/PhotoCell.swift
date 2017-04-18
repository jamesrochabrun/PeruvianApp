//
//  PhotoCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


class PhotoCell: BaseCollectionViewCell {
    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override func setupViews() {
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    func setUp(photoURL: String) {
        
        guard let url = URL(string: photoURL) else {
            print("INVALID URL ON CREATION PHOTOCELL")
            return
        }
        self.photoImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false) {[weak self] (response) in
            guard let image = response.result.value else {
                print("INVALID RESPONSE SETTING UP THE PHOTOCELL")
                return
            }
            self?.photoImageView.image = image
        }
    }
    
    func handleTap(tapGesture: UITapGestureRecognizer) {
        
        guard let imageView = tapGesture.view as? UIImageView else {
            return
        }
        NotificationCenter.default.post(name: Notification.Name.performZoomNotification, object: imageView)
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
}


