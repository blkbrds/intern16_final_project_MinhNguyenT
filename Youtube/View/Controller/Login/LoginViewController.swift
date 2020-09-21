//
//  LoginViewController.swift
//  Youtube
//
//  Created by Khoa Vo T.A. on 9/19/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit
import GoogleSignIn

final class LoginViewController: ViewController {

    @IBOutlet private weak var signInButton: GIDSignInButton!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.style = .wide
        signInButton.layer.cornerRadius = 10
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
}
