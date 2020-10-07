//
//  NaviController.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit
import SDWebImage

final class NavigationBarView: UIView {

    // MARK: - @IBOutlets
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchImageView: ImageView!
    @IBOutlet private weak var profileImageView: ImageView!

    // MARK: - Override functions
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    // MARK: - Private functions
    private func configView() {
        searchView.layer.cornerRadius = searchView.frame.height / 2
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        guard let profileURL = URL(string: Session.shared.userImageURL) else { return }
        profileImageView.sd_setImage(with: profileURL)
    }
}
