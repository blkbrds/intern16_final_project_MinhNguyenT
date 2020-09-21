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
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = ClientID.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        configWindow()
        return true
    }

    private func configWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        changeRoot(rootType: .login)
        window?.makeKeyAndVisible()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance()?.handle(url) ?? false
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            ud.set(user.userID, forKey: UserDefaultKeys.userID)
            ud.set(user.profile.name, forKey: UserDefaultKeys.emailUser)
            ud.set(user.profile.name, forKey: UserDefaultKeys.nameUser)
            if user.profile.hasImage {
                let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 150)
                ud.set(imageUrl?.absoluteString ?? "no image", forKey: UserDefaultKeys.imageUser)
            }
            changeRoot(rootType: .tabbar)
        }
    }

    func changeRoot(rootType: RootType) {
        switch rootType {
        case .login:
            window?.rootViewController = LoginViewController()
        case .tabbar:
            window?.rootViewController = HomeViewController()
        }
    }
}
