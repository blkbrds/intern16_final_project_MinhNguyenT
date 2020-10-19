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

final class HomeCell: TableCell {

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
            updateView()
        }
    }
    weak var delegate: HomeCellDelegate?
    var indexPath: IndexPath?
    // MARK: - Override functions
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        channelImageView.image = nil
        videoImageView.image = nil
    }

    // MARK: - Private functions
    private func configView() {
        durationTimeView.layer.cornerRadius = 10
        videoImageView.layer.cornerRadius = 20
        channelImageView.layer.cornerRadius = channelImageView.frame.height / 2
        subcribeButton.layer.cornerRadius = subcribeButton.frame.height / 2
    }

    private func updateView() {
        guard let video = viewModel.video, let url = URL(string: video.imageURL) else { return }
        videoImageView.sd_setImage(with: url)
        videoTitleLabel.text = video.title
        channelTitleLabel.text = video.channel?.title
        datePublishLabel.text = video.createdTime.convertDateFormatter()
        subcribeButton.isSelected = video.isFavorite
        if video.duration.isNotEmpty {
            durationTimeLabel.text = video.duration.getFormattedDuration()
        } else {
            delegate?.cell(self, needsPerform: .getVideoDuration(indexPath: indexPath))
        }
        guard let urlChannel = URL(string: video.imageChannelURL) else { return }
        channelImageView.sd_setImage(with: urlChannel)
    }

    // MARK: - Functions
    func getChannelImage() {
        viewModel.getChannelImage { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                guard let video = this.viewModel.video, let urlChannel = URL(string: video.imageChannelURL) else { return }
                if let video = this.viewModel.video {
                    this.delegate?.cell(this, needsPerform: .getChannelImageSuccess(video: video))
                }
                this.channelImageView.sd_setImage(with: urlChannel)
            case .failure: break
            }
        }
    }

    // MARK: - IBActions
    @IBAction private func subscriptionButtonTouchUpInside(_ sender: Button) {
        delegate?.cell(self, needsPerform: .handelFavorite(isFavorite: subcribeButton.isSelected))
    }
}

extension HomeCell {
    enum Action {
        case getChannelImageSuccess(video: Video)
        case getVideoDuration(indexPath: IndexPath?)
        case handelFavorite(isFavorite: Bool)
    }
}
