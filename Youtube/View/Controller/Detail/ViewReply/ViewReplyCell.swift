//
//  ViewReplyCell.swift
//  Youtube
//
//  Created by MacBook Pro on 10/15/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

protocol ViewReplyCellDelegate: class {
    func loadReply(_ cell: ViewReplyCell, needPerforms action: ViewReplyCell.Action)
}

final class ViewReplyCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var viewReplyButton: Button!
    weak var delegate: ViewReplyCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        viewReplyButton.tintColor = App.Color.appColor
    }

    // MARK: - IBActions
    @IBAction private func viewReplyButtonTouchUpInside(_ sender: Button) {
        delegate?.loadReply(self, needPerforms: .loadMoReply)
    }
}

extension ViewReplyCell {
    enum Action {
        case loadMoReply
    }
}
