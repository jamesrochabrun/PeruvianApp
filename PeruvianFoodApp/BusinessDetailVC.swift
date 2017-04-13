//
//  BusinessDetailVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class BusinessDetailVC: UITableViewController {

    //MARK: properties
    var business: Business? {
        didSet {
            if let business = business {
                let distance = DistanceViewModel(business: business)
                self.businessDetailDataSource = BusinessDetailDataSource(business: business, distance: distance)
            }
        }
    }
    var businessDetailDataSource: BusinessDetailDataSource? {
        didSet {
            self.businessDetailDataSource?.delegate = self
        }
    }
    
    //MARK: UI
    let calendarView: CalendarView = {
        let v = CalendarView()
        v.alpha = 0
        return v
    }()
    
    //MARK: App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name.dismissViewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSchedule(_ :)), name: NSNotification.Name.showScheduleNotification, object: nil)
    }
    
    func setUpViews() {
        
        view.addSubview(calendarView)
        calendarView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        calendarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        calendarView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calendarView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: UI SetUP
    func setUpTableView() {
        
        tableView.register(HeaderCell.self)
        tableView.register(InfoCell.self)
        tableView.register(SubInfoCell.self)
        tableView.register(HoursCell.self)
        tableView.backgroundColor = .white
        tableView?.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = businessDetailDataSource
    }
    
    //MARK: Navigation
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    //MARK: Notification center
    @objc private func showSchedule(_ notification: NSNotification) {
        //Set the calendar datasource passing the array of scheduleViewModels from ..
        //Cell binds data from Businessdatasource and pass it to the view controller from the HoursCell through notification
        if let openScheduleViewModelArray = notification.object as? [OpenScheduleViewModel] {
            calendarView.openScheduleViewModelArray = openScheduleViewModelArray
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.calendarView.alpha = 1
        })
    }
}

extension BusinessDetailVC: BusinessDetailDataSourceDelegate {
    
    func reloadDataInVC() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            // self?.customIndicator.stopAnimating()
        }
    }
}

//MARK: Tableview height
extension BusinessDetailVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Constants.UI.headerCellHeight
        } else if indexPath.row == 1 {
            return 135//tableView.rowHeight
        }
        return UITableViewAutomaticDimension
    }
}










protocol BusinessDetailDataSourceDelegate: class {
    func reloadDataInVC()
}

class BusinessDetailDataSource: NSObject, UITableViewDataSource {
    
    //MARK : Properties
    weak var delegate: BusinessDetailDataSourceDelegate?
    
    //MARK: 3 main sources of data visual model setted in the networking call
    fileprivate var business: Business?
    var businessViewModel: BusinessViewModel?
    var openScheduleViewModelArray: [OpenScheduleViewModel]?
    //this is for the rocket icon
    var distanceString = ""
    
    //MARK: Initializers
    override init() {
        super.init()
    }
    
    convenience init(business: Business, distance: DistanceViewModel) {
        self.init()
        get(business: business, fromService: YelpService.sharedInstance)
        distanceString = distance.distancePresentable
    }
    
    //MARK: Networking
    private func get(business: Business, fromService service: YelpService) {
        
        service.getBusinessFrom(id: business.businessID) { [weak self] (result) in
            switch result {
            case .Success(let business):
                self?.businessViewModel = BusinessViewModel(model: business, at: nil)
                let hour = business.hours?.first
                self?.openScheduleViewModelArray = hour?.open.map{OpenScheduleViewModel(schedule: $0)}
                self?.businessViewModel?.distance = self?.distanceString ?? ""
                self?.delegate?.reloadDataInVC()
            case .Error(let error):
                print("ERROR ON BUSINESDETAILDATASOURCE: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let businessVM = businessViewModel else {
            return BaseCell()
        }
   
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderCell
            cell.setUp(with: businessVM)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InfoCell
            cell.setUp(with: businessVM)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SubInfoCell
            cell.setUp(with: businessVM)
            return cell
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HoursCell
        cell.openScheduleViewModelArray = openScheduleViewModelArray
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}



class CalendarView: BaseView {
    
    //MARK: - private constant
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
       // cv.contentInset = UIEdgeInsetsMake(0, Constants.UI.scheduleViewPaddingSmall, 0, Constants.UI.scheduleViewPaddingSmall)
        cv.register(ScheduleCell.self)
        return cv
    }()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.darkTextColor)
        v.alpha = 0.8
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
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        })
    }
}

extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ScheduleCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = openScheduleViewModelArray?.count else {
            return 0
        }
        return count
    }
}


class ScheduleCell: BaseCollectionViewCell {
    
    let containerCircle: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return v
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        return l
    }()
    
    let timeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        return l
    }()
    
    override func setupViews() {
        
        backgroundColor = .red
        addSubview(dateLabel)
        addSubview(timeLabel)
        
    }
}










































