//
//  NaviController.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit
import SDWebImage

class NaviController: UIView {

    @IBOutlet private weak var searchImage: ImageView!
    @IBOutlet private weak var profilImage: ImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        searchImage.layer.cornerRadius = searchImage.frame.height / 2
        profilImage.layer.cornerRadius = profilImage.frame.height / 2
        guard let profileURL = URL(string: Session.shared.userImageURL) else { return }
        profilImage.sd_setImage(with: profileURL)
    }

    @IBAction private func searchTapGesture(_ sender: UITapGestureRecognizer) {
        print("search")
    }

    @IBAction private func profileTapGesture(_ sender: UITapGestureRecognizer) {
        print("profile")
    }
}
