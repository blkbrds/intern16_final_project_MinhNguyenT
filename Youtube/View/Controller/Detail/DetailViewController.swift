//
//  DetailViewController.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

final class DetailViewController: ViewController, WKYTPlayerViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var videoView: WKYTPlayerView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        updateUI()
        configBackButton()
        fetchDataDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        TabbarViewController.shared.hiddenTabbar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        TabbarViewController.shared.showTabbar()
    }

    // MARK: - Peroperties
    var viewModel = DetailViewModel()

    // MARK: - Private functions
    private func configBackButton() {
        let backButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "previous"), style: .plain, target: self, action: #selector(backButtonTouchUpInside))
        backButtonItem.tintColor = #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
        navigationItem.leftBarButtonItem = backButtonItem
    }

    private func setUpUI() {
        videoView.layer.cornerRadius = 25
    }

    private func updateUI() {
        let videoNib = UINib(nibName: "VideoCell", bundle: .main)
        tableView.register(videoNib, forCellReuseIdentifier: "VideoCell")
        let channelNib = UINib(nibName: "ChannelCell", bundle: .main)
        tableView.register(channelNib, forCellReuseIdentifier: "ChannelCell")
        let commentNNib = UINib(nibName: "CommentCell", bundle: .main)
        tableView.register(commentNNib, forCellReuseIdentifier: "CommentCell")
        tableView.delegate = self
        tableView.dataSource = self
        videoView.delegate = self
    }

    private func fetchDataDetail() {
        viewModel.loadApiVideoDetail { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.fetchDataChannel()
                this.fetchDataCommetn(isLoadmore: false)
                this.getPlayVIdeo()
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
        }
    }

    private func fetchDataCommetn(isLoadmore: Bool) {
        viewModel.loadApiComment(isLoadMore: isLoadmore) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                if isLoadmore == true {
                    this.tableView.reloadSections(IndexSet(integer: DetailViewModel.SectionType.comment.rawValue), with: .top)
                } else {
                    this.tableView.reloadData()
                }
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
        }
    }

    private func fetchDataChannel() {
        viewModel.loadApiVideoChannel { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
        }
    }

    private func getPlayVIdeo() {
        tableView.reloadData()
        videoView.load(withVideoId: viewModel.video.videoID, playerVars: ["playsinline": 1])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.videoView.playVideo()
        }
    }

    // MARK: - Objc functions
    @objc func backButtonTouchUpInside() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(section: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSecction()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = DetailViewModel.SectionType(rawValue: indexPath.section) else { return UITableViewCell() }
        switch type {
        case .videoDetail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoCell else { return UITableViewCell() }
            cell.viewModel = viewModel.viewModelForDetailCell()
            return cell
        case .videoChannel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ChannelCell else { return UITableViewCell() }
            cell.viewModel = viewModel.viewModelForChannelCell()
            return cell
        case .comment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }
            cell.viewModel = viewModel.viewModelForCommentCell(at: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = DetailViewModel.SectionType(rawValue: section) else { return nil }
        switch sectionType {
        case .videoDetail:
            let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3))
            return view
        case .videoChannel:
            let view: UIView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 10, height: 3))
            view.backgroundColor = .gray
            return view
        case .comment:
            let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            view.backgroundColor = #colorLiteral(red: 0.9809911847, green: 0.9868298173, blue: 1, alpha: 1)
            let commentCountLabel = UILabel(frame: CGRect(x: 15, y: view.frame.midY - 10, width: 200, height: 18))
            view.addSubview(commentCountLabel)
            commentCountLabel.text = "Bình luận (\(viewModel.video.commentCount))"
            commentCountLabel.textColor = #colorLiteral(red: 0.3414462507, green: 0.3415089846, blue: 0.3414379656, alpha: 1)
            return view
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = DetailViewModel.SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .videoDetail:
            return 1
        case .videoChannel:
            return 0.5
        case .comment:
            return 50
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            fetchDataCommetn(isLoadmore: true)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            fetchDataCommetn(isLoadmore: true)
        }
    }
}
