//
//  ReplyViewController.swift
//  Youtube
//
//  Created by MacBook Pro on 10/15/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class ReplyViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: TableView!

    // MARK: - Peroperties
    var viewModel = RepliesViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Relies"
        configBackButton()
        configView()
        fectchDataReply(isloadMore: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        TabbarViewController.shared.hiddenTabbar()
    }

    // MARK: - Private functions
    private func configBackButton() {
        let backButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "previous"), style: .plain, target: self, action: #selector(backButtonTouchUpInside))
        backButtonItem.tintColor = App.Color.appColor
        navigationItem.leftBarButtonItem = backButtonItem
    }

    private func configView() {
        let nib = UINib(nibName: "CommentCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "CommentCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func fectchDataReply(isloadMore: Bool) {
        viewModel.loadApiReply(isLoadMore: isloadMore) { [weak self] (result) in
            guard let this = self else { return }
            this.viewModel.isLoading = false
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
        }
    }

    // MARK: - Objc functions
    @objc private func backButtonTouchUpInside() {
        navigationController?.popViewController(animated: true)
    }
}

extension ReplyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

extension ReplyViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            fectchDataReply(isloadMore: true)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            fectchDataReply(isloadMore: true)
        }
    }
}
