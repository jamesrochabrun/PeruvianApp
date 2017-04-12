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
        addSubview(dismissButton)
        addSubview(overlayView)
        addSubview(businessNameLabel)
        businessNameLabel.sizeToFit()
        addSubview(ratingImageView)
        
        NSLayoutConstraint.activate([
            
            businessImageView.widthAnchor.constraint(equalTo: widthAnchor),
            businessImageView.heightAnchor.constraint(equalTo: heightAnchor),
            businessImageView.leftAnchor.constraint(equalTo: leftAnchor),
            businessImageView.topAnchor.constraint(equalTo: topAnchor),
            
            dismissButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            dismissButton.topAnchor.constraint(equalTo: topAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: Constants.UI.dismissButtonHeight),
            dismissButton.widthAnchor.constraint(equalToConstant: Constants.UI.dismissButtonWidth),
            
            overlayView.leftAnchor.constraint(equalTo: leftAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: 100),
            overlayView.centerYAnchor.constraint(equalTo: centerYAnchor),
            overlayView.widthAnchor.constraint(equalTo: widthAnchor),
            
            businessNameLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            businessNameLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            businessNameLabel.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.7),
            
            ratingImageView.heightAnchor.constraint(equalToConstant: 30),
            ratingImageView.widthAnchor.constraint(equalToConstant: 150),
            ratingImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            ratingImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
            ])
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

        let iconsStackView = UIStackView(arrangedSubviews: [starIconIndicator, priceIndicator, distanceIndicator])
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        iconsStackView.axis = .horizontal
        iconsStackView.distribution = .fillEqually
        addSubview(iconsStackView)
        
        NSLayoutConstraint.activate([
            dividerLine.heightAnchor.constraint(equalToConstant: 0.5),
            dividerLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            iconsStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            iconsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            iconsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconsStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
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
        indicatorLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            
            indicatorImageView.topAnchor.constraint(equalTo: topAnchor),
            indicatorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            indicatorImageView.widthAnchor.constraint(equalTo: indicatorImageView.heightAnchor),
            
            indicatorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            indicatorLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
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
        categoryLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            
            addressLabel.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor),
            addressLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 15),
            addressLabel.widthAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: 0.8),
            
            categoryLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15),
            categoryLabel.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor),
            categoryLabel.widthAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: 0.8),
            categoryLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 15)
            ])
    }
    
    func setUp(with businessViewModel: BusinessViewModel) {
        
        addressLabel.text = businessViewModel.address
        categoryLabel.text = businessViewModel.category
    }
}











