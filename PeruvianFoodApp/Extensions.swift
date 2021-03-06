//
//  Extensions.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation



//MARK: this generic method maps an array of json objects that conform to JSONDecodable and return an array of instantiated objects
extension Collection where Iterator.Element == JSON {
    func decode<T: JSONDecodable>() throws -> [T] {
        return try map{ try T(json: $0)}
    }
}

extension Notification.Name {
    static let dismissViewNotification = Notification.Name("dismiss")
    static let showScheduleNotification = Notification.Name("showSchedule")
    static let showReviewsNotification = Notification.Name("showReviews")
    static let performZoomNotification = Notification.Name("zoom")
    static let openMapVCNotification = Notification.Name("maps")
}


extension UIButton {
    
    func with(title: String ,target:Any, selector:(Selector), cornerRadius: CGFloat, font: String, fontSize: CGFloat, color: String, titleColor: String) {
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(UIColor.hexStringToUIColor(titleColor), for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.titleLabel?.font = UIFont(name: font, size: fontSize)
        self.addTarget(target, action: selector, for: .touchUpInside)
        self.backgroundColor = UIColor.hexStringToUIColor(color)
        self.layer.masksToBounds = true
    }
}
