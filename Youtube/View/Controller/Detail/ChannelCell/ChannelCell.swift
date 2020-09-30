//
//  ChannelCell.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class ChannelCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var channelImage: ImageView!
    @IBOutlet private weak var channelTitleLabel: Label!
    @IBOutlet private weak var subscribeCountLabel: Label!
    @IBOutlet private weak var scribeButton: Button!

    // MARK: - Peroperties
    var viewModel: ChannelViewModel? {
        didSet {
            updateUI()
        }
    }

    private var isScribed: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Functions
    private func setupUI() {
        isScribed = false
        channelImage.layer.cornerRadius = channelImage.frame.height / 2
    }

    func updateUI() {
        guard let video = viewModel?.video?.channel else { return }
        channelTitleLabel.text = video.title
        subscribeCountLabel.text = "\(video.subscriberCount) subscribes"
        guard let urlChannel = URL(string: video.imageURL) else { return }
               channelImage.sd_setImage(with: urlChannel)
        scribeButton.tintColor = .red
    }

    // MARK: - IBActions
    @IBAction private func scribeButtonTouchUpInside(_ sender: Button) {
        if isScribed {
            scribeButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
            scribeButton.tintColor = .red
            isScribed = false
        } else {
            scribeButton.setImage(UIImage(systemName: "bell"), for: .normal)
            scribeButton.tintColor = .red
            isScribed = true
        }
    }
}
