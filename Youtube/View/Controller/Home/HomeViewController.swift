//
//  HomeViewController.swift
//  Youtube
//
//  Created by Khoa Vo T.A. on 9/19/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit
import SVProgressHUD

final class HomeViewController: ViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var tableView: TableView!
    @IBOutlet private weak var navigationBarContainerView: UIView!
    private var navigationBarView: NavigationBarView!

    // MARK: - Peroperties
    var viewModel = HomeViewModel()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavi()
        configTableView()
        getPlaylist(isLoadMore: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl.endRefreshing()
        if tableView.contentOffset.y < 0 {
            tableView.setContentOffset(.zero, animated: false)
        }
    }

    // MARK: - Private functions
    private func configTableView() {
        let nib = UINib(nibName: "HomeCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
    }

    private func configNavi() {
        if navigationBarView == nil {
            guard let navigationBarView = Bundle.main.loadNibNamed("NavigationBarView", owner: self, options: nil)?.first as? NavigationBarView else { return }
            navigationBarView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: App.LayoutGuide.navigationBarHeight)
            navigationBarView.backgroundColor = .clear
            self.navigationBarView = navigationBarView
            navigationBarContainerView.addSubview(self.navigationBarView)
        }
    }

    private func getPlaylist(isLoadMore: Bool) {
        SVProgressHUD.show()
        viewModel.getPlayLists(isLoadMore: isLoadMore) { [weak self] (result) in
            SVProgressHUD.dismiss()
            guard let this = self else { return }
            this.refreshControl.endRefreshing()
            this.viewModel.isLoading = false
            switch result {
            case .success:
                this.tableView.reloadData(moveTop: false) {
                    this.getChannelInfo()
                }
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
        }
    }

    private func getChannelInfo() {
        for cell in tableView.visibleCells {
            if let cell = cell as? HomeCell {
                cell.getChannelImage()
            }
        }
    }

    // MARK: - Objc functions
    @objc private func handleRefresh() {
        getPlaylist(isLoadMore: false)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeCell else { return UITableViewCell() }
        cell.delegate = self
        cell.indexPath = indexPath
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: -
extension HomeViewController: UIScrollViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.viewModel = viewModel.viewModelForDetail(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            getPlaylist(isLoadMore: true)
        }
        if !decelerate {
            getChannelInfo()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            getPlaylist(isLoadMore: true)
        }
        getChannelInfo()
    }
}

// MARK: - HomeCellDelegate
extension HomeViewController: HomeCellDelegate {
    func cell(_ cell: HomeCell, needsPerform action: HomeCell.Action) {
        switch action {
        case .getChannelImageSuccess(video: let video):
            viewModel.updateVideo(video: video)
        case .getVideoDuration(indexPath: let indexPath):
            if let indexPath = indexPath {
                viewModel.getVideoDuration(at: indexPath) { [weak self] (result) in
                    guard let this = self else { return }
                    switch result {
                    case .success:
                        if this.tableView.indexPathsForVisibleRows?.contains(indexPath) == true {
                            this.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    case .failure: break
                    }
                }
            }
        }
    }
}
