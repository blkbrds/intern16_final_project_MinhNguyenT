//
//  IntExt.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation

extension Int {
    func getFormatText() -> String {
        var viewCount: Double = 0.0
        if self < 1_000 {
            return "\(self)"
        } else if self >= 1_000 && self < 1_000_000 {
            viewCount = Double(self) / 1_000
            return "\(Int(viewCount))k"
        } else {
            return "1tr"
        }
    }
}
