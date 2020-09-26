//
//  OptionalExts.swift
//  Youtube
//
//  Created by Khoa Vo T.A. on 9/27/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation

extension Optional {

    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }

    func unwrapped(or error: Error) throws -> Wrapped {
        guard let wrapped = self else { throw error }
        return wrapped
    }
}
