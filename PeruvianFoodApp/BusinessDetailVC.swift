//
//  BusinessDetailVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


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
        } else if indexPath.row == 4 {
            return self.view.frame.width / 3
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
        if let startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil) {
            let zoomingImageView = UIImageView(frame: startingFrame)
            zoomingImageView.contentMode = .scaleAspectFill
            zoomingImageView.image = startingImageView.image
            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(zoomingImageView)
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { 
                    
                    let height = self.getTheHeight(frame1: startingFrame, frame2: keyWindow.frame)
                    
                    let h1 = startingFrame.height  / startingFrame.width * keyWindow.frame.width
                                        
                    zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: h1)
                    zoomingImageView.center = keyWindow.center
                    
                })
            }
        }
    }
    
    //MARK: helper method
    func getTheHeight(frame1: CGRect, frame2: CGRect) -> CGFloat {
        
        //MATH?
        //h2 / w2 = h1 /w1
        //h2 = h1 / w1 * w2
        return frame1.height / frame1.width * frame2.width
    }
}










































