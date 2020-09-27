//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation

final class Session {

    static let shared = Session()

    private init() {}

    func saveLoginInfo(userID: String, userEmail: String, userName: String) {
        self.userID = userID
        self.userEmail = userEmail
        self.userName = userName
    }

    func clearData() {
        isLogin = false
        userID = ""
        userName = ""
        userEmail = ""
        userImageURL = ""
    }

    // MARK: - Status
    var isLogin: Bool {
        get {
            return ud.bool(forKey: App.UserDefaultKey.isLogin)
        }
        set {
            ud.set(newValue, forKey: App.UserDefaultKey.isLogin)
        }
    }

    // MARK: - LoginInfo
    private(set) var userID: String {
        get {
            return ud.string(forKey: App.UserDefaultKey.userID).unwrapped(or: "")
        }
        set {
            ud.set(newValue, forKey: App.UserDefaultKey.userID)
        }
    }

    private(set) var userName: String {
        get {
            return ud.string(forKey: App.UserDefaultKey.userName).unwrapped(or: "")
        }
        set {
            ud.set(newValue, forKey: App.UserDefaultKey.userName)
        }
    }

    private(set) var userEmail: String {
        get {
            return ud.string(forKey: App.UserDefaultKey.userEmail).unwrapped(or: "")
        }
        set {
            ud.set(newValue, forKey: App.UserDefaultKey.userEmail)
        }
    }

    var userImageURL: String {
        get {
            return ud.string(forKey: App.UserDefaultKey.userImageURL).unwrapped(or: "")
        }
        set {
            ud.set(newValue, forKey: App.UserDefaultKey.userImageURL)
        }
    }
}

// MARK: - Protocol
protocol SessionProtocol: class {
}
