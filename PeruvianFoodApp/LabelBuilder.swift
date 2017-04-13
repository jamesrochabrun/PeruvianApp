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
        l.font = UIFont(name: Font.regularFont, size: Font.h1FonstSize)
        l.textColor = textColor.color()
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
        l.font = UIFont(name: Font.regularFont, size: Font.h2FontSize)
        l.textColor = textColor.color()
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
        l.font = UIFont(name: Font.lightFont, size: Font.caption1)
        l.textColor = textColor.color()
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
        l.font = UIFont(name: Font.lightFont, size: Font.caption2)
        l.textColor = textColor.color()
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


struct Font {
    
    static let regularFont: String = "HelveticaNeue"
    static let mediumFont: String = "HelveticaNeue-Medium"
    static let lightFont: String = "HelveticaNeue-Light"
    static let h1FonstSize: CGFloat = 18.0
    static let h2FontSize: CGFloat = 16.0
    static let caption1: CGFloat = 14.0
    static let caption2: CGFloat = 12.0
}


enum Colors {
    
    case appMainColor
    case darkTextColor
    case grayTextColor
    case shadowColor
    case white
    
    func color() -> UIColor {
        switch self {
        case .appMainColor:
            return UIColor.hexStringToUIColor(Constants.Colors.appMainColor)
        case .darkTextColor:
            return UIColor.hexStringToUIColor(Constants.Colors.darkTextColor)
        case .grayTextColor:
            return UIColor.hexStringToUIColor(Constants.Colors.grayTextColor)
        case .shadowColor:
            return UIColor.hexStringToUIColor(Constants.Colors.shadowColor)
        case .white:
            return UIColor.white
        }
    }
}








