//
//  ViewController.swift
//  Youtube
//
//  Created by Khoa Vo T.A. on 9/19/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit
import MVVM

class ViewController: UIViewController, MVVM.View {

    // MARK: - Properties
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.removeMultiTouch()
    }
}
