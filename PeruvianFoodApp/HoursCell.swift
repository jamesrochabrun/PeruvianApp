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
    
    //MARK: Properties
    fileprivate var openScheduleViewModelArray: [OpenScheduleViewModel]?
    
    //MARK: UI Elements
    lazy var scheduleButton: UIButton = {
        return ButtonBuilder.buttonWithBorder(color: .white, width: 1.0, text: "SHOW SCHEDULE", textColor: .white, target: self, selector: #selector(showSchedule)).build()
    }()
    lazy var reviewsButton: UIButton = {
        return ButtonBuilder.buttonWithBorder(color: .white, width: 1.0, text: "SHOW REVIEWS", textColor: .white, target: self, selector: #selector(showReviews)).build()
    }()
    let isOpenNowLabel = LabelBuilder.headerLabel(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    
    //MARK: Setup UI
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

    //MARK: Helper method to set up data cell
    func setUp(with viewModel: BusinessViewModel) {

        if let hours = viewModel.hours?.first  {
            self.openScheduleViewModelArray = hours.open.map{ OpenScheduleViewModel(schedule: $0) }
            isOpenNowLabel.text = HoursViewModel(hours: hours).isOpenNow
        }
    }
    
    //MARK: Notification Center
    @objc private func showSchedule() {
        NotificationCenter.default.post(name: Notification.Name.showScheduleNotification, object: openScheduleViewModelArray)
    }
    
    @objc private func showReviews() {
        NotificationCenter.default.post(name: Notification.Name.showReviewsNotification, object: nil)
    }
    
}







