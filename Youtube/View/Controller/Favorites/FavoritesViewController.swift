//
//  FavoritesViewController.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import UIKit

final class FavoritesViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    var viewModel = FavoriteViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite"
        viewModel.delegate = self
        viewModel.setupObserver()
        configView()
        setupData()
    }

    // MARK: - Private functions
    private func configView() {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic-delete"), style: .plain, target: self, action: #selector(deleteAll))
        navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.tintColor = App.Color.appColor
        let nib = UINib(nibName: "FavoriteCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "FavoriteCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func updateUI() {
        tableView.reloadData()
    }

    private func setupData() {
        fetchData()
    }

    private func fetchData() {
        viewModel.loadData { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure(let error):
                this.showErrorAlert(error: error)
            }
        }
    }

    // MARK: - Objc functions
    @objc private func deleteAll() {
        let alertButton = UIAlertAction(title: App.String.ok, style: .default) { _ in
            self.viewModel.removeAllFavoriteVideos { [weak self] (result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    this.updateUI()
                case .failure(let error):
                    this.showErrorAlert(error: error)
                }
            }
        }
        let cancelButton = UIAlertAction(title: App.String.canncel, style: .cancel, handler: nil)
        let alert = UIAlertController(title: App.String.wanning, message: "", preferredStyle: .alert)
        alert.addAction(alertButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else { return UITableViewCell() }
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}

extension FavoritesViewController: FavoriteViewModelDelegate {
    func viewModel(viewModel: FavoriteViewModel, needsPerform action: FavoriteViewModel.Action) {
        switch action {
        case .reloadData:
            fetchData()
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.handleUnfavorite(at: indexPath) { [weak self] (result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    this.updateUI()
                case .failure(let error):
                    this.showErrorAlert(error: error)
                }
            }
        }
    }
}
