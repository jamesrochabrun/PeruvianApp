//
//  ButtonBuilder.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/17/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

//MARK: App Buttons
enum ButtonBuilder {
    
    case buttonWithBorder(color: Colors, width: CGFloat, text: String, textColor: Colors, target: Any, selector:(Selector))
    case customButton(tintColor: Colors, image: UIImage, target: Any, selector: (Selector))
    case buttonWith(title: String ,target: Any, selector:(Selector), font: String, fontSize: CGFloat, color: Colors, titleColor: Colors)
    case buttonWithCorner(radius: CGFloat, text: String, target: Any, selector: (Selector), backGroundColor: Colors, textColor: Colors)
    
    func build() -> UIButton {
        
        switch self {
        case .buttonWithBorder(let color, let width, let text, let textColor, let target, let selector):
            return createButtonWithBorder(color: color, width: width, text: text, textColor: textColor, target: target, selector: selector)
        case .customButton(let tintColor, let image, let target, let selector):
            return createCustomButton(tintColor: tintColor, image: image, target: target, selector: selector)
        case .buttonWith(let title, let target, let selector, let font, let fontSize, let color, let titleColor):
            return createButtonWith(title: title, target: target, selector: selector, font: font, fontSize: fontSize, color: color, titleColor: titleColor)
        case .buttonWithCorner(let radius, let text, let target, let selector, let backGroundColor, let textColor):
            return createButtonWithCorner(radius: radius, text: text, target: target, selector: selector, backGroundColor: backGroundColor, textColor: textColor)
        }
    }
    
    private func createButtonWithBorder(color: Colors, width: CGFloat, text: String, textColor: Colors, target: Any, selector:(Selector)) -> UIButton {
        
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(text, for: .normal)
        b.setTitleColor(textColor.color(), for: .normal)
        b.addTarget(target, action: selector, for: .touchUpInside)
        b.layer.borderColor = color.color().cgColor
        b.layer.borderWidth = width
        return b
    }
    
    private func createCustomButton(tintColor: Colors, image: UIImage, target: Any, selector: (Selector)) -> UIButton {
        
        let b = UIButton(type: .custom)
        b.tintColor = tintColor.color()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        b.addTarget(target, action: selector, for: .touchUpInside)
        return b
    }
    
    private func createButtonWith(title: String ,target:Any, selector:(Selector), font: String, fontSize: CGFloat, color: Colors, titleColor: Colors) -> UIButton {
        
        let b = UIButton()
        b.setTitle(title, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(titleColor.color(), for: .normal)
        b.titleLabel?.font = UIFont(name: font, size: fontSize)
        b.addTarget(target, action: selector, for: .touchUpInside)
        b.backgroundColor = color.color()
        b.layer.masksToBounds = true
        return b
    }
    
    private func createButtonWithCorner(radius: CGFloat, text: String, target: Any, selector: (Selector), backGroundColor: Colors, textColor: Colors) -> UIButton {
        let b = UIButton()
        b.backgroundColor = backGroundColor.color()
        b.layer.cornerRadius = radius
        b.layer.masksToBounds = true
        b.setTitle(text, for: .normal)
        b.setTitleColor(textColor.color() , for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(target, action: selector, for: .touchUpInside)
        return b
    }
}






