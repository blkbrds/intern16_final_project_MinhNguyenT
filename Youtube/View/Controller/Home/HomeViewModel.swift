//
//  HomeViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 9/21/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomeViewModelDelegate: class {
    func viewModel(viewModel: HomeViewModel, needsPerform action: HomeViewModel.Action)
}

final class HomeViewModel: ViewModel {

    // MARK: - Peroperties
    private var videos: [Video] = []
    private var nextPageToken: String = ""
    var isLoading: Bool = false
    var notification: NotificationToken?
    weak var delegate: HomeViewModelDelegate?

    // MARK: - Functions
    func numberOfItems(inSection section: Int) -> Int {
        return videos.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> HomeCellViewModel {
        return HomeCellViewModel(video: videos[indexPath.row], indexPath: indexPath)
    }

    func viewModelForDetail(at indexPath: IndexPath) -> DetailViewModel {
        return DetailViewModel(video: videos[indexPath.row])
    }

    func updateVideo(video: Video) {
        for (index, video) in videos.enumerated() where video.videoID == video.videoID {
            videos[index] = video
        }
    }

    func getPlayLists(isLoadMore: Bool, completion: @escaping APICompletion) {
        guard !isLoading else { return }
        if !isLoadMore {
            nextPageToken = ""
        }
        isLoading = true
        let params = Api.Home.Params(part: "snippet", keySearch: "trending", key: App.String.apiKey, pageToken: nextPageToken)
        Api.Home.getPlaylist(params: params) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let result):
                if isLoadMore {
                    this.videos.append(contentsOf: result.videos)
                } else {
                    this.videos = result.videos
                }
                this.nextPageToken = result.nextPageToken
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getVideoDuration(at indexPath: IndexPath, completion: @escaping APICompletion) {
        guard videos[indexPath.row].duration.isEmpty else { return }
        let params = Api.Home.DurationParams(part: "contentDetails", key: App.String.apiKey, id: videos[indexPath.row].videoID)
        Api.Home.getVideoDuration(params: params) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let duration):
                this.videos[indexPath.row].duration = duration
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Realm
    func handleFavoriteVideo(at index: Int, completion: ReamlCompletion) {
        do {
            let realm = try Realm()
            let video = videos[index]
            try realm.write {
                video.isFavorite = !video.isFavorite
                realm.create(Video.self, value: video, update: .modified)
            }
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }

    func handleUnfavorite(at index: Int, completion: ReamlCompletion) {
        do {
            let realm = try Realm()
            let video = videos[index]
            if let object = realm.object(ofType: Video.self, forPrimaryKey: video.videoID) {
                try realm.write {
                    realm.delete(object)
                }
                completion(.success)
            }
        } catch {
            completion(.failure(error))
        }
    }

    func setupObserver() {
        do {
            let realm = try Realm()
            notification = realm.objects(Video.self).observe({ [weak self] changes in
                guard let this = self else { return }
                switch changes {
                case .update(let videos, _, _, _):
                    for item in this.videos {
                        if videos.contains(where: { $0.videoID == item.videoID }) {
                            item.isFavorite = true
                        } else {
                            item.isFavorite = false
                        }
                    }
                    this.delegate?.viewModel(viewModel: this, needsPerform: .reloadData)
                default: break
                }
            })
        } catch { }
    }

    func fetchRealmData(completion: @escaping APICompletion) {
      do {
        let realm = try Realm()
        let results = Array(realm.objects(Video.self))
        for item in videos {
          if results.contains(where: { $0.videoID == item.videoID }) {
            item.isFavorite = true
          }
        }
        completion(.success)
      } catch {
        completion(.failure(error))
      }
    }
}

extension HomeViewModel {
    enum Action {
        case reloadData
    }
}
