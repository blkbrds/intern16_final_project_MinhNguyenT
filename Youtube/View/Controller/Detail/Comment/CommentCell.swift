//
//  CommentCell.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class CommentCell: UITableViewCell {

   // MARK: - IBOutlet
    @IBOutlet private weak var profileUserImgae: UIImageView!
    @IBOutlet private weak var nameUserLabel: UILabel!
    @IBOutlet private weak var commentUser: UILabel!

    // MARK: - Peroperties
    var viewModel = CommentViewModel() {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    func setUpUI() {
        profileUserImgae.layer.cornerRadius = profileUserImgae.frame.height / 2
    }

    func updateUI() {
        guard let comment = viewModel.userComment, let url = URL(string: comment.authorImageUrl) else { return }
        profileUserImgae.sd_setImage(with: url)
        nameUserLabel.text = comment.authorName
        commentUser.text = comment.commentDisplay
    }
}
