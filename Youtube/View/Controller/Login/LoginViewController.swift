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

    // MARK: - IBOutlets
    @IBOutlet private weak var signInButton: GIDSignInButton!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarStyle = .lightContent
    }

    // MARK: - Private
    private func configButton() {
        signInButton.style = .wide
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
}
