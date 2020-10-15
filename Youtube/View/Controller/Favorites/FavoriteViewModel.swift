//
//  FavoriteViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 10/8/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import RealmSwift

protocol FavoriteViewModelDelegate: class {
    func viewModel(viewModel: FavoriteViewModel, needsPerform action: FavoriteViewModel.Action)
}

final class FavoriteViewModel: ViewModel {

    // MARK: - Peroperties
    var videos: [Video] = []
    var notification: NotificationToken?
    weak var delegate: FavoriteViewModelDelegate?

    func numberOfItems(inSection section: Int) -> Int {
        return videos.count
    }

    func loadData(completion: @escaping ReamlCompletion) {
        do {
            let realm = try Realm()
            let objects = realm.objects(Video.self).filter("isFavorite == true")
            videos = Array(objects)
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }

    func viewModelForCell(at indexPath: IndexPath) -> FavoriteCellViewModel {
        return FavoriteCellViewModel(video: videos[indexPath.row])
    }

    func setupObserver() {
        do {
            let realm = try Realm()
            notification = realm.objects(Video.self).observe({ [weak self] (action)  in
                guard let this = self else { return }
                switch action {
                case .update:
                    this.delegate?.viewModel(viewModel: this, needsPerform: .reloadData)
                default:
                    break
                }
            })
        } catch { }
    }

    func handleUnfavorite(at indexPath: IndexPath, completion: ReamlCompletion) {
        do {
            let realm = try Realm()
            if let object = realm.object(ofType: Video.self, forPrimaryKey: videos[indexPath.row].videoID) {
                try realm.write {
                    realm.delete(object)
                    let objects = realm.objects(Video.self).filter("isFavorite == true")
                    videos = Array(objects)
                }
            }
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }

    func removeAllFavoriteVideos(completion: ReamlCompletion) {
        do {
            let realm = try Realm()
            let objects = realm.objects(Video.self).filter("isFavorite == true")
            try realm.write {
                realm.delete(objects)
            }
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }
}

extension FavoriteViewModel {
    enum Action {
        case reloadData
    }
}
