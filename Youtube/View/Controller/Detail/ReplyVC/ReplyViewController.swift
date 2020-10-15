//
//  ReplyViewController.swift
//  Youtube
//
//  Created by MacBook Pro on 10/15/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class ReplyViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: TableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Relies"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
