//
//  AppDelegate.swift
//  Youtube
//
//  Created by Khoa Vo T.A. on 9/19/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

enum RootType {
    case login
    case tabbar
}

let ud = UserDefaults.standard
let screenSize = UIScreen.main.bounds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    static let shared: AppDelegate = {
        guard let shared = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot cast `UIApplication.shared.delegate` to `AppDelegate`.")
        }
        return shared
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configFirebase()
        configGIDSignIn()
        configWindow()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if let canBeHandled = GIDSignIn.sharedInstance()?.handle(url) {
            return canBeHandled
        }
        return true
    }

    private func configWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        if Session.shared.isLogin {
            setRoot(rootType: .tabbar)
        } else {
            setRoot(rootType: .login)
        }
    }

    private func configFirebase() {
        FirebaseApp.configure()
    }

    private func configGIDSignIn() {
        GIDSignIn.sharedInstance()?.clientID = ClientID.clientID
        GIDSignIn.sharedInstance()?.delegate = self
    }

    func setRoot(rootType: RootType) {
        switch rootType {
        case .login:
            Session.shared.clearData()
            window?.rootViewController = LoginViewController()
        case .tabbar:
            Session.shared.isLogin = true
            window?.rootViewController = HomeViewController()
        }
    }
}

// MARK: - GIDSignIn
extension AppDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            UIApplication.topViewController()?.showErrorAlert(error: error, completion: { _ in
                self.setRoot(rootType: .login)
            })
        } else {
            Session.shared.saveLoginInfo(userID: user.userID, userEmail: user.profile.email, userName: user.profile.name)
            if let imageURL = signIn.currentUser.profile.imageURL(withDimension: 150), user.profile.hasImage {
                Session.shared.userImageURL = imageURL.absoluteString
            }
            setRoot(rootType: .tabbar)
        }
    }
}
