//
//  BusinessDetailDataSource.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol BusinessDetailDataSourceDelegate: class {
    func passImageViewToVC(_ imageView: UIImageView)
}

final class BusinessDetailDataSource: NSObject, UITableViewDataSource {
    
    //MARK: 2 main sources of data visual model setted in the networking call
    fileprivate var businessViewModel: BusinessViewModel?
    weak var delegate: BusinessDetailDataSourceDelegate?
    
    //MARK: Initializers
    override init() {
        super.init()
    }

    func updateDataWith(_ viewModel: BusinessViewModel) {
        self.businessViewModel = viewModel
    }
    
    //MARK: TableView DataSource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let businessViewModel = businessViewModel else {
            return BaseCell()
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderCell
            cell.setUp(with: businessViewModel)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InfoCell
            cell.setUp(with: businessViewModel)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SubInfoCell
            cell.setUp(with: businessViewModel)
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MapCell
            cell.setUpGoogleMapWith(businessViewModel)
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HoursCell
            cell.setUp(with: businessViewModel)
            return cell
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PhotoAlbumCell
        cell.delegate = self
        cell.photos = businessViewModel.photos 
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}

extension BusinessDetailDataSource: PhotoAlbumCellDelegate {
    
    func passImageView(_ imageView: UIImageView) {
        delegate?.passImageViewToVC(imageView)
    }
}






