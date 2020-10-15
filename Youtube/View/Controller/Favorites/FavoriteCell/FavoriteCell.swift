//
//  FavoriteCell.swift
//  Youtube
//
//  Created by MacBook Pro on 10/8/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class FavoriteCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var channelTitleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    var viewModel: FavoriteCellViewModel? {
        didSet {
            updateView()
        }
    }
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView() {
        guard let video = viewModel?.video, let url = URL(string: video.imageURL) else { return }
        videoImageView.sd_setImage(with: url)
        videoTitleLabel.text = video.title
        channelTitleLabel.text = video.channel?.title
        if video.duration != "" {
            timeLabel.text = video.duration.getFormattedDuration()
        }
    }
}
