//
//  BusinessDetailVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

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
    private var businessDetailDataSource: BusinessDetailDataSource? {
        didSet {
            self.businessDetailDataSource?.delegate = self
        }
    }
    
    //MARK: UI
    private let calendarView: CalendarView = {
        let v = CalendarView()
        v.alpha = 0
        return v
    }()
    
    //Loading Indicator
    fileprivate let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
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
        view.addSubview(customIndicator)
        
        NSLayoutConstraint.activate([
            calendarView.heightAnchor.constraint(equalTo: view.heightAnchor),
            calendarView.widthAnchor.constraint(equalTo: view.widthAnchor),
            calendarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            calendarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            customIndicator.heightAnchor.constraint(equalToConstant: 80),
            customIndicator.widthAnchor.constraint(equalToConstant: 80),
            customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
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
        tableView.register(PhotoAlbumCell.self)
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

//MARK: when datasource is fetched from server perform delegate methods to update UI in VC
extension BusinessDetailVC: BusinessDetailDataSourceDelegate {
    
    func reloadDataInVC() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.customIndicator.stopAnimating()
        }
    }
}

//MARK: Tableview height
extension BusinessDetailVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Constants.UI.headerCellHeight
        } else if indexPath.row == 1 {
            return Constants.UI.infoCellHeight
        } else if indexPath.row == 4 {
            return self.view.frame.width / 3
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
                
                self?.business = business
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
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HoursCell
            cell.openScheduleViewModelArray = openScheduleViewModelArray
            return cell
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PhotoAlbumCell
        cell.photos = business?.photos as? [String]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}


class PhotoAlbumCell: BaseCell {
    
    var photos: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    lazy var photoCollectionView: UICollectionView = {
        let layout = ListLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceHorizontal = true
        cv.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        cv.register(PhotoCell.self)
        cv.isScrollEnabled = false
        return cv
    }()
    
    override func setUpViews() {
        
        addSubview(photoCollectionView)
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}

extension PhotoAlbumCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = photos?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PhotoCell
        if let photoURL = photos?[indexPath.row] {
            cell.setUp(photoURL: photoURL)
        }
        return cell
    }
}


class PhotoCell: BaseCollectionViewCell {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    override func setupViews() {
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    func setUp(photoURL: String) {
        
        guard let url = URL(string: photoURL) else {
            print("INVALID URL ON CREATION PHOTOCELL")
            return
        }
        self.photoImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false) {[weak self] (response) in
            guard let image = response.result.value else {
                print("INVALID RESPONSE SETTING UP THE PHOTOCELL")
                return
            }
            self?.photoImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
}


































