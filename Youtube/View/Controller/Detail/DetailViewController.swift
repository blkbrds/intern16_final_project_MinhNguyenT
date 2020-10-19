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
    @IBOutlet private weak var commentView: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var commentBottomConstrain: NSLayoutConstraint!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        updateUI()
        configBackButton()
        registerObservers()
        fetchDataDetail()
        configFavoriteButton(isFavorite: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        fetchDataRealm()
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
    private func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configBackButton() {
        let backButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "previous"), style: .plain, target: self, action: #selector(backButtonTouchUpInside))
        backButtonItem.tintColor = App.Color.appColor
        navigationItem.leftBarButtonItem = backButtonItem
    }

    private func configFavoriteButton(isFavorite: Bool) {
        var color: UIColor?
        if isFavorite {
            color = App.Color.appColor
        } else {
            color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        let favoriteButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_heart"), style: .plain, target: self, action: #selector(favoriteButtonTouchUpInside))
        navigationItem.rightBarButtonItem = favoriteButtonItem
        favoriteButtonItem.tintColor = color
    }

    private func fetchDataRealm() {
        viewModel.loadFavoriteStatus { [weak self] (isFavorite) in
            self?.configFavoriteButton(isFavorite: isFavorite)
        }
    }

    private func setUpUI() {
        videoView.layer.cornerRadius = 25
    }

    private func updateUI() {
        let videoNib = UINib(nibName: "VideoCell", bundle: .main)
        tableView.register(videoNib, forCellReuseIdentifier: "VideoCell")
        let channelNib = UINib(nibName: "ChannelCell", bundle: .main)
        tableView.register(channelNib, forCellReuseIdentifier: "ChannelCell")
        let commentNib = UINib(nibName: "CommentCell", bundle: .main)
        tableView.register(commentNib, forCellReuseIdentifier: "CommentCell")
        let commentsNib = UINib(nibName: "CommentHeader", bundle: .main)
        tableView.register(commentsNib, forHeaderFooterViewReuseIdentifier: "CommentHeader")
        let viewRepllyNib = UINib(nibName: "ViewReplyCell", bundle: .main)
        tableView.register(viewRepllyNib, forCellReuseIdentifier: "ViewReplyCell")
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
                this.fetchDataRealm()
                this.fetchDataCommetn()
                this.getPlayVIdeo()
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
        }
    }

    private func fetchDataCommetn() {
        viewModel.loadApiComment() { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
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

    private func clearComment() {
        textView.text = ""
    }

    @IBAction private func sendCommentButtonTouchUpinside(_ sender: UIButton) {
        viewModel.postComment(commentText: textView.text) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure:
                break
            }
        }
        view.endEditing(true)
        clearComment()
    }

    // MARK: - Objc functions
    @objc private func keyboardWillAppear(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            commentBottomConstrain.constant = -keyboardHeight + 24
            UIView.animate(withDuration: 0) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        commentBottomConstrain.constant = 0
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func favoriteButtonTouchUpInside() {
        viewModel.handleFavoriteVideo { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                let isFavorite = this.viewModel.video.isFavorite
                this.configFavoriteButton(isFavorite: isFavorite)
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
        }
    }

    @objc private func backButtonTouchUpInside() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSecction()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let type = DetailViewModel.SectionType(rawValue: indexPath.section) {
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
                return UITableViewCell()
            }
        } else {
            if viewModel.numberOfItemsInSection(section: indexPath.row) <= 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }
                cell.viewModel = viewModel.viewModelForReplyCell(at: indexPath)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ViewReplyCell", for: indexPath) as? ViewReplyCell else { return UITableViewCell() }
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionType = DetailViewModel.SectionType(rawValue: section) {
            switch sectionType {
            case .videoDetail:
                let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
                return view
            case .videoChannel:
                let view: UIView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 10, height: 0))
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
        } else {
            guard let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentHeader") as? CommentHeader else { return UITableViewHeaderFooterView() }
            viewHeader.viewModel = viewModel.viewModelForCommentHeader(at: section)
            return viewHeader
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let vc = ReplyViewController()
            vc.viewModel = viewModel.viewModelForReplyDetail(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionType = DetailViewModel.SectionType(rawValue: section) {
            switch sectionType {
            case .videoDetail, .videoChannel:
                return 0
            case .comment:
                return 50
            }
        } else {
            return 100
        }
    }
}
