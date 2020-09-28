//
//  HomeTableViewCell.swift
//  Youtube
//
//  Created by MacBook Pro on 9/21/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit
import SDWebImage

protocol HomeCellDelegate: class {
    func cell(_ cell: HomeCell, needsPerform action: HomeCell.Action)
}

final class HomeCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var videoTitleLabel: Label!
    @IBOutlet private weak var datePublishLabel: Label!
    @IBOutlet private weak var videoImageView: ImageView!
    @IBOutlet private weak var channelImageView: ImageView!
    @IBOutlet private weak var channelTitleLabel: Label!
    @IBOutlet private weak var subcribeButton: Button!
    @IBOutlet private weak var durationTimeView: UIView!
    @IBOutlet private weak var durationTimeLabel: Label!

    // MARK: - Peroperties
    var viewModel: HomeCellViewModel = HomeCellViewModel() {
        didSet {
            updateUI()
        }
    }
    weak var delegate: HomeCellDelegate?
    var indexPath: IndexPath?

    // MARK: - Override functions
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Private functions
    private func setupUI() {
        durationTimeView.layer.cornerRadius = 10
        videoImageView.layer.cornerRadius = 20
        channelImageView.layer.cornerRadius = channelImageView.frame.height / 2
        subcribeButton.layer.cornerRadius = subcribeButton.frame.height / 2
    }

    private func updateUI() {
        guard let video = viewModel.video, let url = URL(string: video.imageURL) else { return }
        videoImageView.sd_setImage(with: url)
        videoTitleLabel.text = video.title
        channelTitleLabel.text = video.channel?.title
        datePublishLabel.text = video.createdTime
        if let duration = viewModel.duration {
            durationTimeLabel.text = duration.getFormattedDuration()
        } else {
            durationTimeLabel.text = nil
            delegate?.cell(self, needsPerform: .getDuration(indexPath: indexPath))
        }
        guard let urlChannel = URL(string: viewModel.imageChannelURL) else { return }
        channelImageView.sd_setImage(with: urlChannel)
    }

    // MARK: - Functions
    func getImageChannel() {
        viewModel.loadImageChannel { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                guard let urlChannel = URL(string: this.viewModel.imageChannelURL) else { return }
                if let video = this.viewModel.video {
                    this.delegate?.cell(this, needsPerform: .callApiSuccess(video: video))
                }
                this.channelImageView.sd_setImage(with: urlChannel)
            case .failure:
                break
            }
        }
    }

    // MARK: - IBActions
    @IBAction private func subscriptionButtonTouchUpInside(_ sender: Button) {
        print("sub")
    }
}

extension HomeCell {
    enum Action {
        case callApiSuccess(video: Video)
        case getDuration(indexPath: IndexPath?)
    }
}
