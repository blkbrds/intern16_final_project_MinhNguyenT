//
//  Font.swift
//  EateryTour
//
//  Created by Khoa Vo T.A. on 9/17/20.
//  Copyright © 2020 Ha Van H.N. All rights reserved.
//

import UIKit

typealias Font = App.Font

extension App {

    struct Font {

        static let header13: UIFont = .sfProTextMedium(ofSize: 13)
        static let header18: UIFont = .sfProTextMedium(ofSize: 18)
        static let header24: UIFont = .sfProTextMedium(ofSize: 24)
        static let header50: UIFont = .sfProTextMedium(ofSize: 50)

        static let content11: UIFont = .sfProTextRegular(ofSize: 11)
        static let content12: UIFont = .sfProTextRegular(ofSize: 12)
        static let content13: UIFont = .sfProTextRegular(ofSize: 13)
        static let content14: UIFont = .sfProTextRegular(ofSize: 14)
        static let content15: UIFont = .sfProTextRegular(ofSize: 15)
        static let content18: UIFont = .sfProTextRegular(ofSize: 18)
        static let content23: UIFont = .sfProTextRegular(ofSize: 23)

        static let bold13: UIFont = .sfProTextBold(ofSize: 13)
        static let bold15: UIFont = .sfProTextBold(ofSize: 15)
        static let bold18: UIFont = .sfProTextBold(ofSize: 18)
        static let bold28: UIFont = .sfProTextBold(ofSize: 28)
        static let sfProTextMedium16: UIFont = .sfProTextMedium(ofSize: 16)
    }
}
