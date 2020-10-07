//
//  VideoCell.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class VideoCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var titleVideoLabel: Label!
    @IBOutlet private weak var viewCountLabel: Label!
    @IBOutlet private weak var likeView: UIView!
    @IBOutlet private weak var dislikeView: UIView!
    @IBOutlet private weak var likeLabel: Label!
    @IBOutlet private weak var dislikeLabel: Label!
    @IBOutlet private weak var shareButton: Button!
    @IBOutlet private weak var addButton: Button!
    @IBOutlet private weak var moreButton: Button!
    @IBOutlet private weak var likeButton: Button!
    @IBOutlet private weak var dislikeButton: Button!

    // MARK: - Peroperties
    private var isLiked: Bool = true
    private var isDisliked: Bool = true

    var viewModel: VideoViewModel? {
        didSet {
            updateUI()
        }
    }

    // MARK: - Private functions
    private func setupUI() {
        likeView.layer.cornerRadius = likeView.frame.height / 2
        likeLabel.textColor = .black
        dislikeLabel.textColor = .black
        dislikeView.layer.cornerRadius = dislikeView.frame.height / 2
        shareButton.layer.cornerRadius = shareButton.frame.height / 2 - 2
        addButton.layer.cornerRadius = addButton.frame.height / 2 - 2
        moreButton.layer.cornerRadius = moreButton.frame.height / 2 - 2
        moreButton.tintColor = .red
        shareButton.tintColor = .red
        addButton.tintColor = .red
        likeButton.layer.cornerRadius = likeButton.frame.height / 2
        dislikeButton.layer.cornerRadius = dislikeButton.frame.height / 2
    }

    func updateUI() {
        guard let video = viewModel?.video else { return }
        titleVideoLabel.text = video.title
        viewCountLabel.text = "\(video.viewCount) views"
        likeLabel.text = "\(Int(video.likeCount)?.getFormatText() ?? "0")"
        dislikeLabel.text = "\(Int(video.dislikeCount)?.getFormatText() ?? "0")"
        setupUI()
    }

    // MARK: - IBActions
    @IBAction private func likeButtonTouchUpInside(_ sender: Button) {
        if isLiked {
            likeLabel.textColor = .white
            likeView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            isLiked = false
            isDisliked = false
        } else {
            likeLabel.textColor = .black
            likeView.backgroundColor = .systemGray6
            isLiked = true
        }
        if isDisliked {
            likeLabel.textColor = .white
            likeView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            dislikeLabel.textColor = .black
            dislikeView.backgroundColor = .systemGray6
            isDisliked = false
            isLiked = false
        } else {
            likeLabel.textColor = .black
            likeView.backgroundColor = .systemGray6
            isDisliked = true
        }
    }

    @IBAction private func dislikeButtonTouchUpInside(_ sender: Button) {
        if isLiked {
            dislikeLabel.textColor = .white
            dislikeView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            isLiked = false
            isDisliked = false
        } else {
            dislikeLabel.textColor = .black
            dislikeView.backgroundColor = .systemGray6
            isLiked = true
        }
        if isDisliked {
            dislikeLabel.textColor = .white
            dislikeView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            likeLabel.textColor = .black
            likeView.backgroundColor = .systemGray6
            isDisliked = false
            isLiked = false
        } else {
            dislikeLabel.textColor = .black
            dislikeView.backgroundColor = .systemGray6
            isDisliked = true
        }
    }
}
