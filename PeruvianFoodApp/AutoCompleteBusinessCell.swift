//
//  AutoCompleteBusinessCell.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/30/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import TRON
import SwiftyJSON
import AlamofireImage

class AutoCompleteBusinessCell: BaseCell {
    
    //MARK: UI elements
    let autoCompleteTextLabel = LabelBuilder.headerLabel(textColor: .darkTextColor, textAlignment: .left, sizeToFit: true).build()
    var businessImageView = ImageViewBuilder.imageView(radius: 10.0, contentMode: .scaleAspectFill, clipsToBounds: true, userInteractionEnabled: false).build()
    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Colors.grayTextColor.color
        return v
    }()
    
    override func setUpViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(autoCompleteTextLabel)
        contentView.addSubview(businessImageView)
        addSubview(dividerLine)
        
        NSLayoutConstraint.activate([
            
            businessImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            businessImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            businessImageView.widthAnchor.constraint(equalToConstant: 40),
            businessImageView.heightAnchor.constraint(equalToConstant: 40),
            
            autoCompleteTextLabel.leftAnchor.constraint(equalTo: businessImageView.rightAnchor, constant: 15),
            autoCompleteTextLabel.centerYAnchor.constraint(equalTo: businessImageView.centerYAnchor),
            
            autoCompleteTextLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -7),
            autoCompleteTextLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            
            dividerLine.heightAnchor.constraint(equalToConstant: 0.3),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.swicthCellPadding),
            dividerLine.rightAnchor.constraint(equalTo: rightAnchor)
            ])
    }
    
    //MARK: setUp data based on type of object that conform to JSONDecodable protocol
    func setUpWith(_ autoCompleteBusiness: AutoCompleteBusiness) {
        
        autoCompleteTextLabel.text = autoCompleteBusiness.name
        getbusinessWith(id: autoCompleteBusiness.id)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        businessImageView.image = nil
    }
    
    //MARK: helper method
    func getbusinessWith(id: String) {
        
        YelpService.sharedInstance.getBusinessWithID(id) { [weak self] (result) in
            guard let strongSelf = self else {
                print("self is nil on Autocomplete cell")
                return }
            switch result {
            case .Success(let business):
                    strongSelf.setUpBusinessImageFrom(business)
            case .Error(let error):
                print("ERROR ON AUTOCOMPLETCELL FETCHING BUSINESS: \(error), id: \(id)")
            }
        }
    }
    
    func setUpBusinessImageFrom(_ business: Business) {
        
        guard let url = URL(string: business.imageURL) else {
            print("INVALID URL ON CREATION BASECELL")
            return
        }
        //let filter = AspectScaledToFillSizeFilter(size: self.businessImageView.frame.size)
        self.businessImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: true) { [weak self] (response) in
            guard let strongSelf = self else {
                print("SELF IS BEEN DEALLOCATED on autocomplete business cell")
                return
            }
            guard let image = response.result.value else {
                print("No image data in response AutocompletCell")
                return
            }
            DispatchQueue.main.async {
                let size = strongSelf.businessImageView.frame.size
                strongSelf.businessImageView.image = image.scaleTo(newSize: size)
            }
        }
    }
}

class AutoCompleteBusinessCellText: BaseCell {
    
    //MARK: UI elements
    let autoCompleteTextLabel = LabelBuilder.headerLabel(textColor: .darkTextColor, textAlignment: .left, sizeToFit: true).build()
    
    let dividerLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Colors.grayTextColor.color
        return v
    }()
    override func setUpViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(autoCompleteTextLabel)
        addSubview(dividerLine)
        
        NSLayoutConstraint.activate([
            
            autoCompleteTextLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 7),
            autoCompleteTextLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 7),
            autoCompleteTextLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -7),
            autoCompleteTextLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            
            dividerLine.heightAnchor.constraint(equalToConstant: 0.3),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.swicthCellPadding),
            dividerLine.rightAnchor.constraint(equalTo: rightAnchor)
            ])
    }
    
    func setUpText(with text: String) {
        autoCompleteTextLabel.text = text
    }
}











