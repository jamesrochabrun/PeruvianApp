//
//  FilterView.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/17/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol FilterViewDelegate: class {
    func cancelWasPressed()
    func searchWasPressedToUpdateSelection(_ selection: Selection)
}

class FilterView: BaseView {
    
    //MARK: properties
    weak var delegate: FilterViewDelegate?
    var selection: Selection?
    
    let toolsView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor).cgColor
        v.layer.borderWidth = 0.7
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.darkTextColor)
        return v
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.with(title: "Cancel", target: self, selector: #selector(hideView), cornerRadius: 0, font: Constants.Font.regularFont, fontSize: 16, color: Constants.Colors.darkTextColor, titleColor: Constants.Colors.white)
        return cancelButton
    }()
    
    lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.with(title: "Search", target: self, selector: #selector(hideViewWithData), cornerRadius: 0, font: Constants.Font.regularFont, fontSize: 16, color: Constants.Colors.darkTextColor, titleColor: Constants.Colors.appSecondaryColor)
        return doneButton
    }()
    
    let containerView: BaseView = {
        let v = BaseView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var priceSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.hexStringToUIColor(Constants.Colors.appSecondaryColor)
        sc.insertSegment(withTitle: "$", at: 0, animated: true)
        sc.insertSegment(withTitle: "$$", at: 1, animated: true)
        sc.insertSegment(withTitle: "$$$", at: 2, animated: true)
        sc.insertSegment(withTitle: "$$$$", at: 3, animated: true)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.addTarget(self, action: #selector(selectPrice), for: .valueChanged)
        return sc
    }()
    
    lazy var distanceSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.hexStringToUIColor(Constants.Colors.appSecondaryColor)
        sc.insertSegment(withTitle: "5 M", at: 0, animated: true)
        sc.insertSegment(withTitle: "10 M", at: 1, animated: true)
        sc.insertSegment(withTitle: "15 M", at: 2, animated: true)
        sc.insertSegment(withTitle: "20 M", at: 3, animated: true)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.addTarget(self, action: #selector(selectDistance), for: .valueChanged)
        return sc
    }()
    
    override func setUpViews() {
        addSubview(toolsView)
        toolsView.addSubview(cancelButton)
        toolsView.addSubview(doneButton)
        addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let segmentsStackView = UIStackView(arrangedSubviews: [distanceSegmentedControl, priceSegmentedControl])
        segmentsStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentsStackView.axis = .vertical
        segmentsStackView.spacing = 20
        segmentsStackView.distribution = .fillEqually
        containerView.addSubview(segmentsStackView)
        
        NSLayoutConstraint.activate([
            toolsView.heightAnchor.constraint(equalToConstant: 44),
            toolsView.widthAnchor.constraint(equalTo: widthAnchor),
            toolsView.topAnchor.constraint(equalTo: topAnchor),
            toolsView.leftAnchor.constraint(equalTo: leftAnchor),
            
            cancelButton.heightAnchor.constraint(equalTo: toolsView.heightAnchor),
            cancelButton.leftAnchor.constraint(equalTo: toolsView.leftAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.topAnchor.constraint(equalTo: toolsView.topAnchor),
            
            doneButton.heightAnchor.constraint(equalTo: toolsView.heightAnchor),
            doneButton.rightAnchor.constraint(equalTo: toolsView.rightAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 100),
            doneButton.topAnchor.constraint(equalTo: toolsView.topAnchor),
            
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.topAnchor.constraint(equalTo: toolsView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            segmentsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            segmentsStackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6),
            segmentsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            segmentsStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
    }
    
    @objc private func hideView() {
        delegate?.cancelWasPressed()
    }
    
    @objc private func hideViewWithData() {
        //update the selection
        if let selection = selection {
            delegate?.searchWasPressedToUpdateSelection(selection)
        }
    }
    
    @objc private func selectPrice() {
        
        switch  priceSegmentedControl.selectedSegmentIndex {
        case 0:
            selection?.price = .oneDollarIcon
        case 1:
            selection?.price = .twoDollarIcon
        case 2:
            selection?.price = .threeDollarIcon
        case 3:
            selection?.price = .fourDollarIcon
        default: break
        }
    }
    
    @objc private func selectDistance() {
        
        switch distanceSegmentedControl.selectedSegmentIndex {
        case 0:
            selection?.radius = .fiveMiles
        case 1:
            selection?.radius = .tenMiles
        case 2:
            selection?.radius = .fifteenMiles
        case 3:
            selection?.radius = .twentyMiles
        default:
            break
        }
    }
}









