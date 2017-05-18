//
//  Constants.swift
//  YelpClient
//
//  Created by James Rochabrun on 4/4/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct UI {
        static let businessCellPadding: CGFloat = 8.0
        static let businessProfileImage: CGFloat = 64.0
        static let swicthCellPadding: CGFloat = 12.0
        static let dismissButtonWidth: CGFloat = 44.0
        static let dismissButtonHeight: CGFloat = 48.0
        static let headerCellHeight: CGFloat = 300
        static let hourCellHeight: CGFloat = 30.0
        static let buttonHourCellHeight: CGFloat = 50.0
        static let hourcellHeightVerticalPadding: CGFloat = 10.0
        static let scheduleViewPaddingSmall: CGFloat = 5.0
        static let scheduleViewPaddingBig: CGFloat = 15.0
        static let scheduleViewPadding: CGFloat = 10.0
        static let infoCellHeight: CGFloat = 100.0
        static let filterViewHeight: CGFloat = 280.0
        static let filterViewButtonsContainerHeight: CGFloat = 44
        static let filterViewButtonsWidth: CGFloat = 100
        static let customIndicatorDefault: CGFloat = 80.0
        static let bubbleContainerHeight: CGFloat = 150.0
        static let mapCellHeight: CGFloat = 140.0
    }
    
    struct Colors {
        static let darkTextColor: String = "#232b2b"//"#282828"
        static let grayTextColor: String = "#353839"
        static let appMainColor: String =  "#662d8c"//"#fbb03b"
        static let appSecondaryColor: String = "#ed1e79"//"#d4145a"
        static let shadowColor: String = "#65737e"
        static let white: String  = "#ffffff"
        static let streetViewBackgroundColor: String = "#595959"
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
}


enum Colors {
    
    case appMainColor
    case darkTextColor
    case grayTextColor
    case shadowColor
    case white
    case appSecondaryColor
    case streetViewBackgroundColor
    
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
            return UIColor.hexStringToUIColor(Constants.Colors.white)
        case .appSecondaryColor:
            return UIColor.hexStringToUIColor(Constants.Colors.appSecondaryColor)
        case .streetViewBackgroundColor:
            return UIColor.hexStringToUIColor(Constants.Colors.streetViewBackgroundColor)

        }
    }
}











