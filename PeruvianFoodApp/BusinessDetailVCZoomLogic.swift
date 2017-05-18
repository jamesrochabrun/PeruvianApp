//
//  BusinessDetailVCZoomLogic.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/17/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

//MARK: custom zoom logic
extension BusinessDetailVC {
    
    func performZoomInForStartingImageView(_ notification: NSNotification) {
        
        guard let startingImageView = notification.object as? UIImageView  else {
            return
        }
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        if let startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil) {
            
            self.startingFrame = startingFrame
            let zoomingImageView = getZoominImageViewWith(startingFrame)
            zoomingImageView.image = startingImageView.image
            
            if let keyWindow = UIApplication.shared.keyWindow {
                backgroundOverlay = UIView(frame: keyWindow.frame)
                backgroundOverlay?.backgroundColor = Colors.darkTextColor.color()
                backgroundOverlay?.alpha = 0
                
                keyWindow.addSubview(backgroundOverlay!)
                keyWindow.addSubview(zoomingImageView)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                    
                    self?.backgroundOverlay?.alpha = 0.7
                    if let height = self?.getTheHeight(frame1: startingFrame, frame2: keyWindow.frame) {
                        zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    }
                    zoomingImageView.center = keyWindow.center
                    
                    }, completion: { (complete) in
                        
                })
            }
        }
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        guard let startingFrame = self.startingFrame, let overlay = self.backgroundOverlay else {
            return
        }
        if let zoomOutImageView = tapGesture.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = startingFrame
                overlay.alpha = 0
            }, completion: { (complete) in
                
                DispatchQueue.main.async { [weak self] in
                    zoomOutImageView.removeFromSuperview()
                    self?.startingImageView?.isHidden = false
                }
            })
        }
    }
    
    //MARK: helper method
    func getTheHeight(frame1: CGRect, frame2: CGRect) -> CGFloat {
        
        //MATH
        //h2 / w2 = h1 /w1
        //h2 = h1 / w1 * w2
        return frame1.height / frame1.width * frame2.width
    }
    
    func getZoominImageViewWith(_ frame: CGRect) -> UIImageView {
        
        let zoomingImageView = UIImageView(frame: frame)
        zoomingImageView.contentMode = .scaleAspectFill
        zoomingImageView.clipsToBounds = true
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        return zoomingImageView
    }
}
