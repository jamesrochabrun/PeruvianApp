//
//  LabelBuilder.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 4/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


enum LabelBuilder {
    
    case headerLabel(textColor: Colors, textAlignment: NSTextAlignment?, sizeToFit: Bool)
    case subHeaderLabel(textColor: Colors, textAlignment: NSTextAlignment?, sizeToFit: Bool)
    case caption1(textColor: Colors, textAlignment: NSTextAlignment?, sizeToFit: Bool)
    case caption2(textColor: Colors, textAlignment: NSTextAlignment?, sizeToFit: Bool)
    
    func build() -> UILabel {
        
        switch self {
        case .headerLabel(let textColor, let textAlignment, let sizeToFit):
            return header(textColor: textColor, textAlignment: textAlignment, sizeToFit: sizeToFit)
        case .subHeaderLabel(let textColor, let textAlignment, let sizeToFit):
            return subHeader(textColor: textColor, textAlignment: textAlignment, sizeToFit: sizeToFit)
        case .caption1(let textColor, let textAlignment, let sizeToFit):
            return cap1(textColor: textColor, textAlignment: textAlignment, sizeToFit: sizeToFit)
        case .caption2(let textColor, let textAlignment, let sizeToFit):
            return cap2(textColor: textColor, textAlignment: textAlignment, sizeToFit: sizeToFit)
        }
    }
    
    private func header(textColor: Colors, textAlignment: NSTextAlignment?, sizeToFit: Bool) -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.font = UIFont(name: Constants.Font.regularFont, size: Constants.Font.h1FonstSize)
        l.textColor = textColor.color
        l.textAlignment = textAlignment ?? .left
        if sizeToFit {
            l.sizeToFit()
        }
        return l
    }
    
    private func subHeader(textColor: Colors, textAlignment: NSTextAlignment?, sizeToFit: Bool) -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.font = UIFont(name: Constants.Font.regularFont, size: Constants.Font.h2FontSize)
        l.textColor = textColor.color
        l.textAlignment = textAlignment ?? .left
        if sizeToFit {
            l.sizeToFit()
        }
        return l
    }
    
    private func cap1(textColor: Colors, textAlignment: NSTextAlignment?, sizeToFit: Bool) -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.font = UIFont(name: Constants.Font.lightFont, size: Constants.Font.caption1)
        l.textColor = textColor.color
        l.textAlignment = textAlignment ?? .left
        if sizeToFit {
            l.sizeToFit()
        }
        return l
    }
    
    private func cap2(textColor: Colors, textAlignment: NSTextAlignment?, sizeToFit: Bool) -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.font = UIFont(name: Constants.Font.lightFont, size: Constants.Font.caption2)
        l.textColor = textColor.color
        l.textAlignment = textAlignment ?? .left
        if sizeToFit {
            l.sizeToFit()
        }
        return l
    }
    
    static func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
}










