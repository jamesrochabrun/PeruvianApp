//
//  BusinessDetailVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

final class BusinessDetailVC: UIViewController {

    //MARK: properties
    var businessID: String? {
        didSet {
            if let businessID = businessID {
                self.animatedView.startAnimation()
                getBusinessWith(businessID)
            }
        }
    }
    var businessViewModel: BusinessViewModel?
    lazy var dataSource: BusinessDetailDataSource = {
        let ds = BusinessDetailDataSource()
        ds.delegate = self
        return ds
    }()
    
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
        tv.register(MapCell.self)
        tv.dataSource = self.dataSource
        return tv
    }()
    
    let animatedView: AnimatedLoadingView = {
        let av = AnimatedLoadingView(name: Constants.AnimationFiles.bounchingBall, speed: 0.8, loop: true)
        return av
    }()
    
    //MARK: Networking call
    func getBusinessWith(_ businessID: String) {
        
        YelpService.sharedInstance.getBusinessWithID(businessID, completionQueue: DispatchQueue.main) { [weak self] (result) in
            guard let strongSelf = self else {
                print("SELF IS BEEN DEALLOCATED ON NETWORKING CALL FOR BUSINEES DETAIL")
                return
            }
            switch result {
            case .Success(let business):
                strongSelf.businessViewModel = BusinessViewModel(model: business)
                // self?.businessViewModel?.distance = businessViewModel.distance
                if let viewModel = strongSelf.businessViewModel {
                    strongSelf.dataSource.updateDataWith(viewModel)
                    strongSelf.reloadDataInVC()
                }
            case .Error(let error):
                print("ERROR ON BUSINES DETAIL DATASOURCE: \(error)")
                strongSelf.alertUserOfError()
            }
        }
    }
    
    //MARK: App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name.dismissViewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSchedule(_ :)), name: NSNotification.Name.showScheduleNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showReviews), name: NSNotification.Name.showReviewsNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToMapVC), name: Notification.Name.openMapVCNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpViews() {
        
        view.backgroundColor = .white
        view.addSubview(gradientView)
        view.addSubview(tableView)
        view.addSubview(statusBarBackgroundView)
        view.addSubview(dismissButton)
        view.addSubview(calendarView)
        view.addSubview(animatedView)
        
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
            animatedView.heightAnchor.constraint(equalToConstant: Constants.UI.animationViewSize),
            animatedView.widthAnchor.constraint(equalToConstant: Constants.UI.animationViewSize),
            animatedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    //MARK: Navigation
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc private func showReviews() {
        
        let reviewsVC = ReviewsVC()
        reviewsVC.businessViewModel = businessViewModel
        let navController = UINavigationController(rootViewController: reviewsVC)
        present(navController, animated: true, completion: nil)
    }
    
    //MARK: Notification center shows calendarView
    @objc private func showSchedule(_ notification: NSNotification) {
        
        //Set the calendar datasource passing the array of scheduleViewModels from ..
        //Cell binds data from Businessdatasource and pass it to the view controller from the HoursCell through notification
        if let openScheduleViewModelArray = notification.object as? [OpenScheduleViewModel] {
            calendarView.openScheduleViewModelArray = openScheduleViewModelArray
        } else {
            calendarView.scheduleLabel.text = "No schedule available"
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarView.alpha = 1
        })
    }
}

//MARK: Updates
extension BusinessDetailVC {
    
    func reloadDataInVC() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.animatedView.stopAnimation()
            UIView.animate(withDuration: 0.3, animations: { 
                self.gradientView.alpha = 1
            })
        }  
    }
    
    func alertUserOfError() {
        showAlertWith(title: "Sorry", message: "Something went wrong, try again please", style: .alert)
    }
    
    //MARK: helper method
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK: UITableViewDelegate delegate methods
extension BusinessDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return Constants.UI.headerCellHeight
        case 1:
            return Constants.UI.infoCellHeight
        case 3:
            return Constants.UI.mapCellHeight
        case 5:
            return self.view.frame.width / 3
        default:
            return UITableViewAutomaticDimension
        }
    }
}

//MARK: Triggered by notification from Mapcell
extension BusinessDetailVC {
    
    @objc fileprivate func goToMapVC() {
        
        let mapVC = MapVC()
        mapVC.businessViewModel = businessViewModel
        self.present(mapVC, animated: true)
    }
}









































