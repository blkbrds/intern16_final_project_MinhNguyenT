//
//  DetailViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import UIKit

final class DetailViewModel {

    // MARK: - Peroperties
    var video: Video
    var isLoading: Bool = false
    var pageToken: String = ""

    init(video: Video = Video()) {
        self.video = video
    }

    func viewModelForDetailCell() -> VideoViewModel {
        return VideoViewModel(video: video)
    }

    func viewModelForChannelCell() -> ChannelViewModel {
        return ChannelViewModel(video: video)
    }

    func viewModelForCommentCell(at indexPath: IndexPath) -> CommentViewModel {
        return CommentViewModel(comment: video.comments[indexPath.row])
    }

    func numberOfSecction() -> Int {
        return SectionType.allCases.count
    }

    func numberOfItems(section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .videoDetail:
            return 1
        case .videoChannel:
            return 1
        case .comment:
            return video.comments.count
        }
    }

    func heightForRowAt(at indexPath: IndexPath) -> CGFloat {
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return .zero }
        switch sectionType {
        case .videoDetail:
            return UITableView.automaticDimension
        case .videoChannel:
            return 70
        case .comment:
            return 100
        }
    }

    func loadApiComment(isLoadMore: Bool, completion: @escaping APICompletion) {
        guard !isLoading else {
            completion(.failure(Api.Error.invalid))
            return
        }
        isLoading = true
        let params = Api.Detail.CommentParams(part: "snippet", videoId: video.videoID, key: App.String.apiKey, maxResults: 5, pageToken: pageToken)
        Api.Detail.getComments(params: params) { [weak self] (result) in
            guard let this = self else { return }
            this.isLoading = false
            switch result {
            case .success(let result):
                if isLoadMore {
                    this.video.comments.append(contentsOf: result.comments)
                } else {
                    this.video.comments = result.comments
                }
                this.pageToken = result.pageToken
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadApiVideoChannel(completion: @escaping APICompletion) {
        guard let id = video.channel?.id else {
            completion(.failure(Api.Error.invalid))
            return
        }
        let part: [String] = ["snippet", "statistics"]
        let parms = Api.Detail.VideoChannelParams(part: part.joined(separator: ","), key: App.String.apiKey, id: id)
        Api.Detail.getVideoChannel(params: parms) { [weak self] (result) in
            guard let this = self else {
                completion(.failure(Api.Error.invalid))
                return
            }
            switch result {
            case .success(let channel):
                if let channel = channel {
                    this.video.channel = channel
                }
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadApiVideoDetail(completion: @escaping APICompletion) {
        let part: [String] = ["snippet", "statistics"]
        let parms = Api.Detail.VideoDetailParams(part: part.joined(separator: ","), id: video.videoID, key: App.String.apiKey)
        Api.Detail.getVideoDetail(params: parms) { [weak self] (result) in
            guard let this = self else {
                completion(.failure(Api.Error.invalid))
                return
            }
            switch result {
            case .success(let video):
                this.video = video
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func postComment(commentText: String, completion: @escaping APICompletion) {
        let params = Api.Comment.AllParams(snippet: "snippet", channelId: video.channel?.id ?? "", videoId: video.videoID, textOriginal: commentText, key: App.String.apiKey)
        Api.Comment.postComments(params: params) { (result) in
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension DetailViewModel {

    enum SectionType: Int, CaseIterable {
        case videoDetail
        case videoChannel
        case comment
    }
}
