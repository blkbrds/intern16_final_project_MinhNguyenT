//
//  CommentHeader.swift
//  Youtube
//
//  Created by MacBook Pro on 10/14/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class CommentHeader: UITableViewHeaderFooterView {

    // MARK: - IBOutlets
    @IBOutlet private weak var authorImageView: ImageView!
    @IBOutlet private weak var authorNameLabel: Label!
    @IBOutlet private weak var authorComentLable: Label!

    var viewModel: CommentHeaderViewModel? {
        didSet {
            updateView()
        }
    }

    func updateView() {
        authorImageView.layer.cornerRadius = authorImageView.frame.height / 2
        guard let comment = viewModel?.userComment, let url = URL(string: comment.authorImageUrl) else { return }
        authorImageView.sd_setImage(with: url)
        authorNameLabel.text = "\(comment.authorName) - \(comment.publishedAt.convertDateFormatter())"
        authorComentLable.text = comment.commentDisplay
    }
}
