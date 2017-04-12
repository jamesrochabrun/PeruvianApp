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
    
    //MARK: App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name.dismissViewNotification, object: nil)
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
    func dismissView() {
        self.dismiss(animated: true)
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

//MARK: Tableview
extension BusinessDetailVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Constants.UI.headerCellHeight
        } else if indexPath.row == 1 {
            return 135//tableView.rowHeight
        } else if indexPath.row == 2 {
            return UITableViewAutomaticDimension
        }
        return 100//UITableViewAutomaticDimension
    }
}

protocol BusinessDetailDataSourceDelegate: class {
    func reloadDataInVC()
}

class BusinessDetailDataSource: NSObject, UITableViewDataSource {
    
    //MARK : Properties
    weak var delegate: BusinessDetailDataSourceDelegate?
    fileprivate var businessViewModel: BusinessViewModel? {
        didSet {
            delegate?.reloadDataInVC()
        }
    }
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
                self?.businessViewModel?.distance = self?.distanceString ?? ""
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}


class HoursCell: BaseCell, UITableViewDelegate, UITableViewDataSource {
    
    lazy var datesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(HourCell.self)
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        tv.backgroundColor = .red
        tv.estimatedRowHeight = 100
        tv.rowHeight = UITableViewAutomaticDimension
        return tv
    }()

    override func setUpViews() {
        
        //MARK: laying out the tablewview dynamically
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(datesTableView)
        
        NSLayoutConstraint.activate([
            
            //Layout for tableview
            datesTableView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10),
            datesTableView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            datesTableView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            datesTableView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 10)
            
            ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HourCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}



class HourCell: BaseCell {
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        l.text = "Monday open between 10:00 until 4:00pm 'lkh'lkh'lkh'lkh'lkh 1990"
        return l
    }()
    
    override func setUpViews() {
        
        backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        contentView.addSubview(dateLabel)
        dateLabel.sizeToFit()
        let marginGuides = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            
            dateLabel.topAnchor.constraint(equalTo: marginGuides.topAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: marginGuides.bottomAnchor, constant: -10),
            dateLabel.leftAnchor.constraint(equalTo: marginGuides.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: marginGuides.rightAnchor)
            ])
    }
    
}






class HoursDataSource: NSObject, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HourCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}


























