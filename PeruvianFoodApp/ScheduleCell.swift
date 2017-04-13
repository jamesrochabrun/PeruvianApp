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
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    override func setupViews() {
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        
        addSubview(dateLabel)
        dateLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    func setUp(schedule: OpenScheduleViewModel) {
        dateLabel.text = schedule.fullSchedulePresentable
    }
}
