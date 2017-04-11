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
            return 150//tableView.rowHeight
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
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SubInfoCell
        cell.setUp(with: businessVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

class HeaderCell: BaseCell {
    
    let businessImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .center
        iv.clipsToBounds = true
        return iv
    }()
    
    let businessNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    let overlayView: UIView = {
        let v = UIView()
        v.blur(with : .light)
        v.opaque(with: Constants.Colors.darkTextColor, alpha: 0.05)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .center
        iv.clipsToBounds = true
        return iv
    }()
    
    let dismissButton: CustomDismissButton = {
        let dbv = CustomDismissButton()
        return dbv
    }()
    
    override func setUpViews() {
    
        addSubview(businessImageView)
        businessImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        businessImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        businessImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        businessImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(dismissButton)
        dismissButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        dismissButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: Constants.UI.dismissButtonHeight).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: Constants.UI.dismissButtonWidth).isActive = true
        
        addSubview(overlayView)
        overlayView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        overlayView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        overlayView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        addSubview(businessNameLabel)
        businessNameLabel.sizeToFit()
        businessNameLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
        businessNameLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        businessNameLabel.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.7).isActive = true
        
        addSubview(ratingImageView)
        ratingImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ratingImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        ratingImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        ratingImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        businessImageView.loadImageUsingCacheWithURLString(businessViewModel.profileImageURL, placeHolder: nil) { (complete) in
        }
        businessNameLabel.text = businessViewModel.name
        let reviewIcon = ReviewIcon(reviewNumber: businessViewModel.rating)
        ratingImageView.image = reviewIcon.image
    }
}

class InfoCell: BaseCell {
    
    let starIconIndicator: IconIndicatorView = {
        let siv = IconIndicatorView()
        siv.indicatorImageView.image = #imageLiteral(resourceName: "star").withRenderingMode(.alwaysTemplate)
        siv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return siv
    }()
    
    let priceIndicator: IconIndicatorView = {
        let siv = IconIndicatorView()
        siv.indicatorImageView.image = #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate)
        siv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return siv
    }()
    
    let distanceIndicator: IconIndicatorView = {
        let siv = IconIndicatorView()
        siv.indicatorImageView.image = #imageLiteral(resourceName: "distance").withRenderingMode(.alwaysTemplate)
        siv.tintColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return siv
    }()
    
    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return v
    }()
    
    override func setUpViews() {

        addTopShadowWith(radius: 7.0, fromColor: .black, toColor: .white)
        
        addSubview(dividerLine)
        dividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        dividerLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true

        let iconsStackView = UIStackView(arrangedSubviews: [starIconIndicator, priceIndicator, distanceIndicator])
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        iconsStackView.axis = .horizontal
        iconsStackView.distribution = .fillEqually
        
        addSubview(iconsStackView)
        iconsStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        iconsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        iconsStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconsStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        starIconIndicator.indicatorLabel.text = businessViewModel.textRating
        priceIndicator.indicatorLabel.text = businessViewModel.price
        distanceIndicator.indicatorLabel.text = businessViewModel.distance
    }
}

class IconIndicatorView: BaseView {
    
    let indicatorImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let indicatorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.numberOfLines = 0
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return l
    }()
    
    override func setUpViews() {
        
        addSubview(indicatorImageView)
        addSubview(indicatorLabel)
        
        indicatorImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indicatorImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicatorImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        indicatorImageView.widthAnchor.constraint(equalTo: indicatorImageView.heightAnchor).isActive = true
        
        indicatorLabel.sizeToFit()
        indicatorLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        indicatorLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        indicatorLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}

class SubInfoCell: BaseCell {
    
    let addressLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textAlignment = .left
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return l
    }()
    
    let categoryLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textAlignment = .left
        l.textColor = UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        return l
    }()
    
    override func setUpViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(addressLabel)
        contentView.addSubview(categoryLabel)
        
        addressLabel.sizeToFit()
        addressLabel.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 15).isActive = true
        addressLabel.widthAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: 0.8).isActive = true
        
        categoryLabel.sizeToFit()
        categoryLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15).isActive = true
        categoryLabel.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor).isActive = true
        categoryLabel.widthAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: 0.8).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 15).isActive = true
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        
        addressLabel.text = businessViewModel.address
        categoryLabel.text = businessViewModel.category

    }
}











