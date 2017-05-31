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
    func setUpWith(data: [JSONDecodable], atIndex index: Int) {
        
        businessImageView.layer.borderWidth = 5.0
        
        if let autoCompleteBusinesses = data as? [AutoCompleteBusiness] {
            
            autoCompleteTextLabel.text = autoCompleteBusinesses[index].name
            autoCompleteTextLabel.backgroundColor = .yellow
            setBusinessImageViewFrom(id: autoCompleteBusinesses[index].id)
            businessImageView.layer.borderColor = UIColor.yellow.cgColor
            
        } else if let autoCompleteTerms = data as? [AutoCompleteTerm] {
            
            autoCompleteTextLabel.text = autoCompleteTerms[index].text
            autoCompleteTextLabel.backgroundColor = .green
            businessImageView.layer.borderColor = UIColor.green.cgColor
            businessImageView.image = nil
            
        } else if let autoCompleteCategories = data as? [AutoCompleteCategory] {
            
            autoCompleteTextLabel.text = autoCompleteCategories[index].title
            autoCompleteTextLabel.backgroundColor = .red
            businessImageView.layer.borderColor = UIColor.red.cgColor
            businessImageView.image = nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        businessImageView.image = nil
    }
    
    //MARK: helper method
    func setBusinessImageViewFrom(id: String) {
        
        YelpService.sharedInstance.getBusinessWithID(id) { [weak self] (result) in
            switch result {
            case .Success(let business):
                
                guard let url = URL(string: business.imageURL) else {
                    print("INVALID URL ON CREATION BASECELL")
                    return
                }
                self?.businessImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: true) { [weak self] (response) in
                    guard let image = response.result.value else {
                        print("No image data in response AutocompletCell")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.businessImageView.image = image
                    }
                }
            case .Error(let error):
                print("ERROR ON AUTOCOMPLETCELL FETCHING BUSINESS: \(error)")
            }
        }
    }
}

