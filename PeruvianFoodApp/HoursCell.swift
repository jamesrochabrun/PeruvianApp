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
    
//    lazy var scheduleButton: UIButton = {
//        let b = UIButton()
//        b.translatesAutoresizingMaskIntoConstraints = false
//        b.setTitle("SHOW SCHEDULE", for: .normal)
//        b.setTitleColor(UIColor.hexStringToUIColor(Constants.Colors.white), for: .normal)
//        b.addTarget(self, action: #selector(showSchedule), for: .touchUpInside)
//       // b.layer.borderColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor).cgColor
//      //  b.layer.borderWidth = 1.0
//        b.layer.cornerRadius = 20
//        b.layer.masksToBounds = true
//        return b
//    }()
    
    //MARK: UI Elements
    lazy var scheduleButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("SHOW SCHEDULE", for: .normal)
        b.setTitleColor(UIColor.hexStringToUIColor(Constants.Colors.white), for: .normal)
        b.addTarget(self, action: #selector(showSchedule), for: .touchUpInside)
        b.layer.borderColor = UIColor.hexStringToUIColor(Constants.Colors.white).cgColor
        b.layer.borderWidth = 1.0
//        b.layer.cornerRadius = 20
//        b.layer.masksToBounds = true
        return b
    }()
    
    lazy var reviewsButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("SHOW REVIEWS", for: .normal)
        b.setTitleColor(UIColor.hexStringToUIColor(Constants.Colors.white), for: .normal)
        b.addTarget(self, action: #selector(showReviews), for: .touchUpInside)
        b.layer.borderColor = UIColor.hexStringToUIColor(Constants.Colors.white).cgColor
        b.layer.borderWidth = 1.0
        //        b.layer.cornerRadius = 20
        //        b.layer.masksToBounds = true
        return b
    }()
    
    let isOpenNowLabel = LabelBuilder.headerLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    
    override func setUpViews() {
        
        contentView.addSubview(isOpenNowLabel)
        contentView.addSubview(scheduleButton)
        contentView.addSubview(reviewsButton)
        let marginGuide = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            
            isOpenNowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            isOpenNowLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: Constants.UI.buttonHourCellHeight),
            scheduleButton.topAnchor.constraint(equalTo: isOpenNowLabel.bottomAnchor, constant: Constants.UI.hourcellHeightVerticalPadding),
            scheduleButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            scheduleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            reviewsButton.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: Constants.UI.hourcellHeightVerticalPadding + 5),
            reviewsButton.widthAnchor.constraint(equalTo: scheduleButton.widthAnchor),
            reviewsButton.heightAnchor.constraint(equalTo: scheduleButton.heightAnchor),
            reviewsButton.centerXAnchor.constraint(equalTo: scheduleButton.centerXAnchor),
            reviewsButton.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -Constants.UI.hourcellHeightVerticalPadding)
            ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      //  scheduleButton.gradient(withStartColor: .appMainColor, endColor: .appSecondaryColor, isHorizontal: true, isFlipped: false)
    }
    
    func setUp(with viewModel: BusinessViewModel) {

        if let hours = viewModel.hours?.first  {
            self.openScheduleViewModelArray = hours.open.map{OpenScheduleViewModel(schedule: $0)}
            isOpenNowLabel.text = HoursViewModel(hours: hours).isOpenNow
        }
    }
    
    @objc private func showSchedule() {
        NotificationCenter.default.post(name: Notification.Name.showScheduleNotification, object: openScheduleViewModelArray)
    }
    
    @objc private func showReviews() {
        NotificationCenter.default.post(name: Notification.Name.showReviewsNotification, object: nil)
    }
    
}







