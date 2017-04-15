//
//  CalendarView.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/12/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CalendarView: BaseView {
    
    //MARK: - properties
    var openScheduleViewModelArray: [OpenScheduleViewModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.dateCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - UI Element
    lazy var dateCollectionView: UICollectionView = {
        let layout = GridLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.alwaysBounceHorizontal = false
        cv.alwaysBounceVertical = false
        cv.dataSource = self
        cv.register(ScheduleCell.self)
        return cv
    }()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.darkTextColor)
        v.alpha = 0.7
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSelf)))
        return v
    }()
    
    let scheduleLabel: UILabel = {
        let l = UILabel()
        l.text = "Schedule"
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        return l
    }()
    
    //MARK: SET Up UI
    override func setUpViews() {
        
        addSubview(containerView)
        addSubview(dateCollectionView)
        addSubview(scheduleLabel)
        // dateCollectionView.dataSource = calendarDataSource
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dateCollectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            dateCollectionView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            dateCollectionView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dateCollectionView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 20),
            
            scheduleLabel.bottomAnchor.constraint(equalTo: dateCollectionView.topAnchor, constant: -Constants.UI.scheduleViewPadding),
            scheduleLabel.widthAnchor.constraint(equalTo: dateCollectionView.widthAnchor),
            scheduleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    //MARK: handle selectors
    func hideSelf() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        })
    }
}

extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ScheduleCell
        if let scheduleViewModel = openScheduleViewModelArray?[indexPath.row] {
            cell.setUp(schedule: scheduleViewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = openScheduleViewModelArray?.count else {
            return 0
        }
        return count
    }
}

