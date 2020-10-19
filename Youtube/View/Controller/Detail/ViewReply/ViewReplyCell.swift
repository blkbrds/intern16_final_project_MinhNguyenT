//
//  ViewReplyCell.swift
//  Youtube
//
//  Created by MacBook Pro on 10/15/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class ViewReplyCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var viewReplyButton: Button!

    // MARK: - Peroperties
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewReplyButton.tintColor = App.Color.appColor
    }
}
