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
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tabbarView: UIView!
    @IBOutlet private weak var subscribeButton: Button!
    @IBOutlet private weak var subscribeButtonImageView: ImageView!
    @IBOutlet private weak var homeButton: Button!
    @IBOutlet private weak var homeButtonImageView: ImageView!
    @IBOutlet private weak var homeButtonTitleLabel: Label!
    @IBOutlet private var tabbarItemButton: [UIButton]!
    @IBOutlet private weak var tabbarViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Peroperties
    static var shared = TabbarViewController()
    private let homeVC = HomeViewController()
    private let favoriteVC = FavoritesViewController()
    private var selectedIndex: Int = 0
    private var viewControllers: [UIViewController] = []

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
    }

    // MARK: - Private functions
    private func configTabbar() {
        let homeNavi = UINavigationController(rootViewController: homeVC)
        let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
        viewControllers = [homeNavi, favoriteNavi]
        tabbarItemButton[selectedIndex].isSelected = true
        tabbarItemButtonTouchUpInside(tabbarItemButton[selectedIndex])
        tabbarViewHeightConstraint.constant = App.LayoutGuide.tabBarHeight
        tabbarView.layer.cornerRadius = tabbarViewHeightConstraint.constant / 2
        homeButton.layer.cornerRadius = (tabbarViewHeightConstraint.constant - 30) / 2
    }

    func hiddenTabbar() {
        tabbarView.isHidden = true
        tabbarViewHeightConstraint.constant = 0
    }

    func showTabbar() {
        tabbarView.isHidden = false
        tabbarViewHeightConstraint.constant = 90
    }

    // MARK: - @IBActions
    @IBAction private func tabbarItemButtonTouchUpInside(_ sender: UIButton) {
        if sender.tag == 0 {
            homeButtonImageView.tintColor = App.Color.appColor
            homeButtonTitleLabel.textColor = App.Color.appColor
            subscribeButtonImageView.tintColor = .black
        } else {
            homeButtonImageView.tintColor = .black
            homeButtonTitleLabel.textColor = .black
            subscribeButtonImageView.tintColor = App.Color.appColor
        }
        selectedIndex = sender.tag
        let previousVC = viewControllers[selectedIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}
