//
//  HomeViewController.swift
//  Youtube
//
//  Created by Khoa Vo T.A. on 9/19/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var naviView: UIView!
    private var navi: NaviController!

    // MARK: - Peroperties
    var viewModel = HomeViewModel()
    private var tableRefreshControl = UIRefreshControl()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        refreshVideo()
        getPlaylist(isLoadMore: false)
        configNavi()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Private functions
    private func configTableView() {
        let nib = UINib(nibName: "HomeCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configNavi() {
        if navi == nil {
            guard let navi = Bundle.main.loadNibNamed("NaviController", owner: self, options: nil)?.first as? NaviController else { return }
            navi.frame = CGRect(x: 0, y: 0, width: naviView.frame.width, height: naviView.frame.height)
            navi.backgroundColor = .clear
            self.navi = navi
            naviView.addSubview(self.navi)
        }
    }

    private func refreshVideo() {
        tableRefreshControl.tintColor = .black
        let tableViewAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tableRefreshControl.attributedTitle = NSAttributedString(string: "", attributes: tableViewAttributes)
        tableRefreshControl.addTarget(self, action: #selector(tableViewDidScroll), for: .valueChanged)
        tableView.addSubview(tableRefreshControl)
    }

    private func getPlaylist(isLoadMore: Bool) {
        viewModel.loadApiForVideos(isLoadMore: isLoadMore) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.updateUI()
                for cell in this.tableView.visibleCells {
                    if let cell = cell as? HomeCell {
                        cell.getImageChannel()
                    }
                }
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
            this.viewModel.isLoading = false
        }
    }

    private func updateUI() {
        tableView.reloadData()
        tableRefreshControl.endRefreshing()
    }

    // MARK: - Objc functions
    @objc private func tableViewDidScroll() {
        getPlaylist(isLoadMore: false)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeCell else { return UITableViewCell() }
        cell.indexPath = indexPath
        cell.delegate = self
        cell.viewModel = viewModel.viewModelForItem(atIndexPath: indexPath)
        return cell
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            getPlaylist(isLoadMore: true)
        }
        if !decelerate {
            for cell in tableView.visibleCells {
                if let cell = cell as? HomeCell {
                    cell.getImageChannel()
                }
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            getPlaylist(isLoadMore: true)
        }
        for cell in tableView.visibleCells {
            if let cell = cell as? HomeCell {
                cell.getImageChannel()
            }
        }
    }
}

// MARK: - HomeCellDelegate
extension HomeViewController: HomeCellDelegate {
    func cell(_ cell: HomeCell, needsPerform action: HomeCell.Action) {
        switch action {
        case .callApiSuccess(video: let video):
            viewModel.updateImageChannel(video: video)
        case .getDuration(indexPath: let indexPath):
            if let indexPath = indexPath {
                viewModel.loadApiVideoDuration(at: indexPath) { [weak self] (result) in
                    guard let this = self else { return }
                    switch result {
                    case .success:
                        if this.tableView.indexPathsForVisibleRows?.contains(indexPath) == true {
                            this.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    case .failure:
                        break
                    }
                }
            }
        }
    }
}
