//
//  DeviceType.swift
//  Youtube
//
//  Created by Khoa Vo T.A. on 10/4/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

public enum DeviceType {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6p
    case iPhoneX
    case iPhoneXS
    case iPhoneXR
    case iPhoneXSMax

    public var size: CGSize {
        switch self {
        case .iPhone4: return CGSize(width: 320, height: 480)
        case .iPhone5: return CGSize(width: 320, height: 568)
        case .iPhone6: return CGSize(width: 375, height: 667)
        case .iPhone6p: return CGSize(width: 414, height: 736)
        case .iPhoneX: return CGSize(width: 375, height: 812)
        case .iPhoneXS: return CGSize(width: 375, height: 812)
        case .iPhoneXR: return CGSize(width: 414, height: 896)
        case .iPhoneXSMax: return CGSize(width: 414, height: 896)
        }
    }
}

let kScreenSize = UIScreen.main.bounds.size
let ratioWidth = kScreenSize.width / DeviceType.iPhone6.size.width
let ratioHeight = kScreenSize.height / DeviceType.iPhone6.size.height

let iPhone = (UIDevice.current.userInterfaceIdiom == .phone)
let iPad = (UIDevice.current.userInterfaceIdiom == .pad)

let iPhone4 = (iPhone && DeviceType.iPhone4.size == kScreenSize)
let iPhone5 = (iPhone && DeviceType.iPhone5.size == kScreenSize)
let iPhone6 = (iPhone && DeviceType.iPhone6.size == kScreenSize)
let iPhone6p = (iPhone && DeviceType.iPhone6p.size == kScreenSize)
let iPhoneX = (iPhone && DeviceType.iPhoneX.size == kScreenSize)
let iPhoneXS = (iPhone && DeviceType.iPhoneXS.size == kScreenSize)
let iPhoneXR = (iPhone && DeviceType.iPhoneXR.size == kScreenSize)
let iPhoneXSMax = (iPhone && DeviceType.iPhoneXSMax.size == kScreenSize)
