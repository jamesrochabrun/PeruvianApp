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
    var business: Business? {
        didSet {
            if let business = business, let hour = business.hours?.first  {
                self.openScheduleViewModelArray = hour.open.map{OpenScheduleViewModel(schedule: $0)}
                isOpenNowLabel.text = HoursViewModel(hours: hour).isOpenNow
            }
        }
    }
    
    lazy var scheduleButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Show Schedule", for: .normal)
        b.setTitleColor(UIColor.hexStringToUIColor(Constants.Colors.appMainColor), for: .normal)
        b.addTarget(self, action: #selector(showSchedule), for: .touchUpInside)
        b.layer.borderColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor).cgColor
        b.layer.borderWidth = 1.0
        return b
    }()
    
    let isOpenNowLabel = LabelBuilder.headerLabel(textColor: .grayTextColor, textAlignment: .center, sizeToFit: true).build()
    
    override func setUpViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(isOpenNowLabel)
        contentView.addSubview(scheduleButton)
        NSLayoutConstraint.activate([
            
            isOpenNowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
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







