//
//  UIFontExt.swift
//  EateryTour
//
//  Created by Khoa Vo T.A. on 9/17/20.
//  Copyright © 2020 Ha Van H.N. All rights reserved.
//

import UIKit

enum FontType {
    case sfProTextRegular
    case sfProTextBold
    case sfProTextMedium
    case sfProTextLight
    case sfProTextSemibold

    /// font name
    var name: String {
        switch self {
        case .sfProTextRegular:
            return "SFProText-Regular"
        case .sfProTextBold:
            return "SFProText-Bold"
        case .sfProTextMedium:
            return "SFProText-Medium"
        case .sfProTextLight:
            return "SFProText-Light"
        case .sfProTextSemibold:
            return "SFProText-Semibold"
        }
    }
}

extension UIFont {

    ///- Parameter size: The font size of the sfProTextRegular
    static func sfProTextRegular(ofSize size: CGFloat) -> UIFont! {
        return UIFont(type: .sfProTextRegular, size: size)
    }

    ///- Parameter size: The font size of the sfProTextBold
    static func sfProTextBold(ofSize size: CGFloat) -> UIFont! {
        return UIFont(type: .sfProTextBold, size: size)
    }

    ///- Parameter size: The font size of the sfProTextMedium
    static func sfProTextMedium(ofSize size: CGFloat) -> UIFont! {
        return UIFont(type: .sfProTextMedium, size: size)
    }

    ///- Parameter size: The font size of the sfProTextLight
    static func sfProTextLight(ofSize size: CGFloat) -> UIFont! {
        return UIFont(type: .sfProTextLight, size: size)
    }

    ///- Parameter size: The font size of the sfProTextSemibold
    static func sfProTextSemibold(ofSize size: CGFloat) -> UIFont! {
        return UIFont(type: .sfProTextSemibold, size: size)
    }

    /**
    Initialized font size with type
     - Parameter fontType: The type of font, is defined in FontType enum
     - Parameter size: The font size
     */
    convenience init?(type fontType: FontType, size: CGFloat) {
        self.init(name: fontType.name, size: size)
    }
}
