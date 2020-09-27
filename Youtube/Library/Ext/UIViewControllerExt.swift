//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String?,
                   message: String?,
                   buttonTitles: [String]? = nil,
                   highlightedButtonIndex: Int? = nil,
                   completion: ((Int) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.isEmpty {
            allButtons.append("OK")
        }
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
    }

    func showErrorAlert(error: Error, completion: ((Int) -> Void)? = nil) {
        showAlert(title: "",
                  message: error.localizedDescription,
                  buttonTitles: ["OK"],
                  completion: completion)
    }
}
