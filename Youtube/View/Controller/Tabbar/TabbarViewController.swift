//
//  TabbarViewController.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class TabbarViewController: ViewController {

    // MARK: - @IBOutlets
    @IBOutlet private weak var conternerView: UIView!
    @IBOutlet private weak var subscribeButton: Button!
    @IBOutlet private weak var homeButton: Button!
    @IBOutlet private weak var tabbarView: UIView!
    @IBOutlet private var tabbarItemButton: [UIButton]!
    @IBOutlet private weak var tabbarHeightConstraint: NSLayoutConstraint!

    static var shared = TabbarViewController()

    // MARK: - Peroperties
    private let homeVC = HomeViewController()
    private let subScriptionVC = SubscriptionViewController()
    private var selectIndex: Int = 1
    private var viewControllers: [UIViewController] = []

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let homeNavi = UINavigationController(rootViewController: homeVC)
        let subNavi = UINavigationController(rootViewController: subScriptionVC)
        viewControllers = [homeNavi, subNavi]
        tabbarItemButton[selectIndex].isSelected = true
        tabbarItemsTouchUpInSide(tabbarItemButton[selectIndex])
    }

    // MARK: - Private functions
    private func setupUI() {
        subscribeButton.layer.cornerRadius = 20
        homeButton.layer.cornerRadius = homeButton.frame.height / 2
        tabbarView.layer.cornerRadius = 40
    }

    func hiddenTabbar() {
        tabbarView.isHidden = true
        tabbarHeightConstraint.constant = 0
    }

    func showTabbar() {
        tabbarView.isHidden = false
        tabbarHeightConstraint.constant = 90
    }

    // MARK: - @IBActions
    @IBAction private func tabbarItemsTouchUpInSide(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setTitleColor(.red, for: .normal)
            homeButton.tintColor = .red
            subscribeButton.tintColor = .black
        } else {
            sender.setTitleColor(.red, for: .normal)
            homeButton.setTitleColor(.black, for: .normal)
            subscribeButton.tintColor = .red
            homeButton.tintColor = .black
        }
        selectIndex = sender.tag
        let previousVC = viewControllers[selectIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        sender.isSelected = true
        let vc = viewControllers[selectIndex]
        addChild(vc)
        vc.view.frame = conternerView.bounds
        conternerView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}
