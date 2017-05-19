//
//  CategoryFeedVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class MainCategoriesVC: UIViewController {
    
    //MARK: Properties
    let dataSource = MainCategoriesDataSource(categoriesViewModelArray: [])
    var mainCategoryViewModel = MainCategoryViewModel()
    let circularTransition = CircularTransition()
    
    //MARK: UI
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.estimatedRowHeight = 100
        tv.rowHeight = UITableViewAutomaticDimension
        tv.separatorStyle = .none
        tv.register(CategoryCell.self)
        tv.dataSource = self.dataSource
        tv.bounces = false
        return tv
    }()
    
    lazy var transitionButton: UIButton = {
        return ButtonBuilder.buttonWithImage(image: #imageLiteral(resourceName: "cameraButton"), renderMode: false, tintColor: .appSecondaryColor, target: self, selector: #selector(openCamera), radius: Constants.UI.cameraButtonRadius).build()
    }()
    
    //MARK: APP lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadCategories()
        setUPNavBar()
        self.title = "Categories"
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            transitionButton.heightAnchor.constraint(equalToConstant: Constants.UI.cameraButtonSize),
            transitionButton.widthAnchor.constraint(equalToConstant: Constants.UI.cameraButtonSize),
            transitionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            transitionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
            ])
    }
    
    func loadCategories() {
        
        mainCategoryViewModel.getMainCategories { [weak self] (mainCategoriesArray) in
            self?.dataSource.update(with: mainCategoriesArray)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    //MARK: Set up UI
    private func setUpViews() {
        view.addSubview(tableView)
        view.addSubview(transitionButton)
    }
    
    private func setUPNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Foodie", style: .plain, target: self, action: #selector(openFoodieVC))
    }
    
    @objc private func openCamera() {
        
        let cameraVC = CameraVC()
        cameraVC.transitioningDelegate = self
        cameraVC.modalPresentationStyle = .custom
        self.present(cameraVC, animated: true)
    }
    
    @objc private func openFoodieVC() {
    
    }
}

//MARK: tableview delegate
extension MainCategoriesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainCategoryViewModel = dataSource.getMainCategoryViewModelFrom(indexPath)
        let subCategoriesVC = SubCategoriesVC()
        subCategoriesVC.mainCategoryViewModel = mainCategoryViewModel
        self.navigationController?.pushViewController(subCategoriesVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.size.height - 64) / 3
    }
}

//MARK: UIViewControllerTransitioningDelegate, custom transition logic
extension MainCategoriesVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        circularTransition.transitionMode = .present
        circularTransition.startingPoint = transitionButton.center
        circularTransition.circleColor = Colors.cameraButtonBackgroundColor.color()
        return circularTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        circularTransition.transitionMode = .dismiss
        circularTransition.startingPoint = transitionButton.center
        circularTransition.circleColor = Colors.cameraButtonBackgroundColor.color()
        return circularTransition
    }
}









