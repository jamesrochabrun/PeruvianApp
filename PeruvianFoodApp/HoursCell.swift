//
//  HoursCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class HoursCell: BaseCell {
    
    var openScheduleViewModelArray: [OpenScheduleViewModel]?
    
    lazy var scheduleButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Show Schedule", for: .normal)
        b.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(showSchedule), for: .touchUpInside)
        b.layer.cornerRadius = 15.0
        b.layer.masksToBounds = true
        return b
    }()
    
    let isOpenNowLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.text = "CLOSED"
        return l
    }()
    
    override func setUpViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(isOpenNowLabel)
        isOpenNowLabel.sizeToFit()
        contentView.addSubview(scheduleButton)
        NSLayoutConstraint.activate([
            
            isOpenNowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: Constants.UI.hourcellHeightVerticalPadding),
            isOpenNowLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: Constants.UI.buttonHourCellHeight),
            
            scheduleButton.topAnchor.constraint(equalTo: isOpenNowLabel.bottomAnchor, constant: Constants.UI.hourcellHeightVerticalPadding),
            scheduleButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            scheduleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            scheduleButton.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -Constants.UI.hourcellHeightVerticalPadding)
            ])
    }
    
    @objc private func showSchedule() {
        NotificationCenter.default.post(name: Notification.Name.showScheduleNotification, object: openScheduleViewModelArray)
    }
}
