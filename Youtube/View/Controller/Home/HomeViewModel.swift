//
//  HomeViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 9/21/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation

final class HomeViewModel: ViewModel {

    // MARK: - Peroperties
    private var videos: [Video] = []
    private var nextPageToken: String = ""
    var isLoading: Bool = false

    // MARK: - Functions
    func numberOfItems(inSection section: Int) -> Int {
        return videos.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> HomeCellViewModel {
        return HomeCellViewModel(video: videos[indexPath.row], indexPath: indexPath)
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
}
