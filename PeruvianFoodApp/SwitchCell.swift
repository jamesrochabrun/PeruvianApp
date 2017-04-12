//
//  SwitchCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/6/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol SwitchCellDelegate: class {
    func switchCell(_ cell: SwitchCell)
}

class SwitchCell: BaseCell {
    
    weak var delegate: SwitchCellDelegate?
    
    lazy var customSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = false
        s.translatesAutoresizingMaskIntoConstraints = false
        s.thumbTintColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        s.addTarget(self, action: #selector(switchValue), for: .valueChanged)
        s.onImage = #imageLiteral(resourceName: "Yelp_burst_positive_RGB")
        s.offImage = #imageLiteral(resourceName: "Yelp_burst_negative_RGB")
        s.onTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return s
    }()
    
    let swithCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.hexStringToUIColor(Constants.Colors.darkTextColor)
        return label
    }()
    
    func switchValue() {
        delegate?.switchCell(self)
    }
    
    func setUpCell(with viewModel: CategoryItemViewModel) {
        swithCategoryLabel.text = viewModel.itemTitle
        customSwitch.setOn(viewModel.isSelected, animated: false)
    }
    
    override func setUpViews() {
        
        selectionStyle = .none
        addSubview(swithCategoryLabel)
        addSubview(customSwitch)
        
        swithCategoryLabel.sizeToFit()
        customSwitch.sizeToFit()
        
        NSLayoutConstraint.activate([
            
            swithCategoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.swicthCellPadding),
            swithCategoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            customSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.UI.swicthCellPadding),
            customSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}









