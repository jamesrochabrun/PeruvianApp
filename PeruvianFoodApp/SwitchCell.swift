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
    
    //MARK: properties
    weak var delegate: SwitchCellDelegate?
    
    //MARK: UI elements
    lazy var customSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = false
        s.sizeToFit()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.thumbTintColor = Colors.appSecondaryColor.color
        s.addTarget(self, action: #selector(switchValue), for: .valueChanged)
        s.onTintColor = Colors.appMainColor.color
        return s
    }()
    let swithCategoryLabel = LabelBuilder.headerLabel(textColor: .darkTextColor, textAlignment: nil, sizeToFit: true).build()
    
    //MARK: SetUp UI
    override func setUpViews() {
        
        selectionStyle = .none
        addSubview(swithCategoryLabel)
        addSubview(customSwitch)
        
        NSLayoutConstraint.activate([
            swithCategoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.swicthCellPadding),
            swithCategoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            customSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.UI.swicthCellPadding),
            customSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    //MARK: Helper method for set up cell data
    func setUpCell(with viewModel: SubCategoryViewModel) {
        swithCategoryLabel.text = viewModel.itemTitle
        customSwitch.setOn(viewModel.isSelected, animated: false)
    }
    
    //MARK: delegate method
    func switchValue() {
        delegate?.switchCell(self)
    }
}









