//
//  BusinessDetailVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class BusinessDetailVC: UIViewController {

    //MARK: properties
    var businessViewModel: BusinessViewModel? {
        didSet {
            if let businessViewModel = businessViewModel {
                self.businessDetailDataSource = BusinessDetailDataSource(businessViewModel: businessViewModel)
            }
        }
    }
    
    private var businessDetailDataSource: BusinessDetailDataSource? {
        didSet {
            self.businessDetailDataSource?.delegate = self
        }
    }
    //MARK: Zoom frame UI
    var startingFrame: CGRect?
    var backgroundOverlay: UIView?
    var startingImageView: UIImageView?
    
    //MARK: UI Elements
    private lazy var calendarView: CalendarView = {
        let v = CalendarView()
        v.alpha = 0
        return v
    }()
    
    fileprivate lazy var gradientView: UIView = {
        let g = UIView(frame: self.view.bounds)
        g.gradient(withStartColor: .appMainColor, endColor: .appSecondaryColor, isHorizontal: false, isFlipped: false)
        g.alpha = 0
        return g
    }()
    
    let statusBarBackgroundView: BaseView = {
        let v = BaseView()
        v.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        return v
    }()
    
    let dismissButton: CustomDismissButton = {
        let dbv = CustomDismissButton()
        return dbv
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.estimatedRowHeight = 100
        tv.allowsSelection = false
        tv.rowHeight = UITableViewAutomaticDimension
        tv.separatorStyle = .none
        tv.register(HeaderCell.self)
        tv.register(InfoCell.self)
        tv.register(SubInfoCell.self)
        tv.register(HoursCell.self)
        tv.register(PhotoAlbumCell.self)
        tv.dataSource = self.businessDetailDataSource
        return tv
    }()
    
    fileprivate let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    //MARK: App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name.dismissViewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSchedule(_ :)), name: NSNotification.Name.showScheduleNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showReviews), name: NSNotification.Name.showReviewsNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(performZoomInForStartingImageView(_ :)), name: NSNotification.Name.performZoomNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            
            statusBarBackgroundView.heightAnchor.constraint(equalToConstant: 22),
            statusBarBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            dismissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            dismissButton.topAnchor.constraint(equalTo: statusBarBackgroundView.bottomAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: Constants.UI.dismissButtonHeight),
            dismissButton.widthAnchor.constraint(equalToConstant: Constants.UI.dismissButtonWidth),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 22),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
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
    
    //MARK: UI SetUP Tableview
    private func setUpTableView() {
        
        tableView.register(HeaderCell.self)
        tableView.register(InfoCell.self)
        tableView.register(SubInfoCell.self)
        tableView.register(HoursCell.self)
        tableView.register(PhotoAlbumCell.self)
        tableView.register(MapCell.self)
        tableView.dataSource = businessDetailDataSource
    }
    
    private func setUpViews() {
        
        view.backgroundColor = .white
        view.addSubview(gradientView)
        view.addSubview(tableView)
        view.addSubview(statusBarBackgroundView)
        view.addSubview(dismissButton)
        view.addSubview(calendarView)
        view.addSubview(customIndicator)
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
    
    func showReviews() {
        
        let reviewsVC = ReviewsVC()
        reviewsVC.businessViewModel = businessViewModel
        //add a navigation controller
        let navController = UINavigationController(rootViewController: reviewsVC)
        present(navController, animated: true, completion: nil)
    }
}

//MARK: when datasource is fetched from server perform delegate methods to update UI in VC
extension BusinessDetailVC: BusinessDetailDataSourceDelegate {
    
    func reloadDataInVC() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.customIndicator.stopAnimating()
            UIView.animate(withDuration: 0.3, animations: { 
                self?.gradientView.alpha = 1
            })
        }
    }
}

//MARK: Tableview height
extension BusinessDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Constants.UI.headerCellHeight
        } else if indexPath.row == 1 {
            return Constants.UI.infoCellHeight
        } else if indexPath.row == 5 {
            return self.view.frame.width / 3
        } else if indexPath.row == 3 {
            return 140
        }
        return UITableViewAutomaticDimension
    }
}

//MARK: custom zoom logic
extension BusinessDetailVC {
    
    func performZoomInForStartingImageView(_ notification: NSNotification) {
        
        guard let startingImageView = notification.object as? UIImageView  else {
            return
        }
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        if let startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil) {
            
            self.startingFrame = startingFrame
            let zoomingImageView = getZoominImageViewWith(startingFrame)
            zoomingImageView.image = startingImageView.image
            
            if let keyWindow = UIApplication.shared.keyWindow {
                backgroundOverlay = UIView(frame: keyWindow.frame)
                backgroundOverlay?.backgroundColor = UIColor.hexStringToUIColor(Constants.Colors.darkTextColor)
                backgroundOverlay?.alpha = 0
                
                keyWindow.addSubview(backgroundOverlay!)
                keyWindow.addSubview(zoomingImageView)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                    
                    self?.backgroundOverlay?.alpha = 0.7
                    if let height = self?.getTheHeight(frame1: startingFrame, frame2: keyWindow.frame) {
                        zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    }
                    zoomingImageView.center = keyWindow.center
    
                }, completion: { (complete) in
                    
                })
            }
        }
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        guard let startingFrame = self.startingFrame, let overlay = self.backgroundOverlay else {
            return
        }
        if let zoomOutImageView = tapGesture.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = startingFrame
                overlay.alpha = 0
            }, completion: { (complete) in
                
                DispatchQueue.main.async { [weak self] in
                    zoomOutImageView.removeFromSuperview()
                    self?.startingImageView?.isHidden = false
                }
            })
        }
    }
    
    //MARK: helper method
    func getTheHeight(frame1: CGRect, frame2: CGRect) -> CGFloat {
        
        //MATH?
        //h2 / w2 = h1 /w1
        //h2 = h1 / w1 * w2
        return frame1.height / frame1.width * frame2.width
    }
    
    func getZoominImageViewWith(_ frame: CGRect) -> UIImageView {
        
        let zoomingImageView = UIImageView(frame: frame)
        zoomingImageView.contentMode = .scaleAspectFill
        zoomingImageView.clipsToBounds = true
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        return zoomingImageView
    }
}









class MapCell: BaseCell {
    
    var googleMap = GMSMapView()
    lazy var actionView: BaseView = {
        let v = BaseView()
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnMap)))
        v.isUserInteractionEnabled = true
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            actionView.topAnchor.constraint(equalTo: topAnchor),
            actionView.leftAnchor.constraint(equalTo: leftAnchor),
            actionView.widthAnchor.constraint(equalTo: widthAnchor),
            actionView.heightAnchor.constraint(equalTo: heightAnchor),
            googleMap.topAnchor.constraint(equalTo: topAnchor),
            googleMap.leftAnchor.constraint(equalTo: leftAnchor),
            googleMap.widthAnchor.constraint(equalTo: widthAnchor),
            googleMap.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
    func setUpGoogleMapWith(_ viewModel: BusinessViewModel) {
        
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude, zoom: 16)
        googleMap = GMSMapView.map(withFrame: .zero, camera: camera)
        googleMap.mapType = .normal
        googleMap.translatesAutoresizingMaskIntoConstraints = false
        addSubview(googleMap)
        addSubview(actionView)
        setUpMarkerDataWith(viewModel)
    }
    
    private func setUpMarkerDataWith(_ viewModel: BusinessViewModel) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "markerIcon")
        marker.map = nil
        draw(marker)
    }
    
    private func draw(_ marker: GMSMarker) {
        
        if marker.map == nil {
            marker.map = self.googleMap
        }
    }
    
    @objc private func handleTapOnMap() {
        
    }
}





































