//
//  ScheduleCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class ScheduleCell: BaseCollectionViewCell {
    
    let dateLabel = LabelBuilder.caption1(textColor: .white, textAlignment: .center, sizeToFit: true).build()
    
    override func setupViews() {
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    func setUp(schedule: OpenScheduleViewModel) {
        dateLabel.text = schedule.fullSchedulePresentable
    }
}
