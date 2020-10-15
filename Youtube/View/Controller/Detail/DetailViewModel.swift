//
//  DetailViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class DetailViewModel {

    // MARK: - Peroperties
    var video: Video
    var comments: [Comment] = []
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

    func viewModelForReplyCell(at indexPath: IndexPath) -> CommentViewModel {
        return CommentViewModel(replies: comments[indexPath.section - SectionType.allCases.count].reply[indexPath.row])
    }

    func viewModelForCommentHeader(at section: Int) -> CommentHeaderViewModel {
        return CommentHeaderViewModel(comment: comments[section - SectionType.allCases.count])
    }

    func numberOfSecction() -> Int {
        return SectionType.allCases.count + comments.count
    }

    func numberOfItemsInSection(section: Int) -> Int {
        if let sectionType = SectionType(rawValue: section) {
            switch sectionType {
            case .videoDetail, .videoChannel, .comment:
                return 1
            }
        } else {
            if comments[section - SectionType.allCases.count].reply.count <= 3 {
                return comments[section - SectionType.allCases.count].reply.count
            } else {
                return 4
            }
        }
    }

    func heightForRowAt(at indexPath: IndexPath) -> CGFloat {
        if let sectionType = SectionType(rawValue: indexPath.section) {
            switch sectionType {
            case .videoDetail:
                return UITableView.automaticDimension
            case .videoChannel:
                return 70
            case .comment:
                return 0.0
            }
        } else {
            return UITableView.automaticDimension
        }
    }

    func loadApiComment(isLoadMore: Bool, completion: @escaping APICompletion) {
        let params = Api.Detail.CommentParams(part: "snippet", videoId: video.videoID, key: App.String.apiKey, maxResults: 5, pageToken: pageToken)
        Api.Detail.getComments(params: params) { [weak self] (result) in
            guard let this = self else { return }
            this.isLoading = false
            switch result {
            case .success(let result):
                this.comments = result.comments
                let dispatchGroup = DispatchGroup()
                for index in 0 ..< this.comments.count {
                    dispatchGroup.enter()
                    this.loadApiReply(commentIndex: index, isLoadMore: false) { _ in
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadApiReply(commentIndex: Int, isLoadMore: Bool, completion: @escaping APICompletion) {
        let params = Api.Detail.ReplyParams(part: "snippet", parentId: comments[commentIndex].id, key: App.String.apiKey, maxResults: 10, pageToken: pageToken)
        Api.Detail.getReply(params: params) { [weak self] (result) in
            guard let this = self else { return }
            this.isLoading = false
            switch result {
            case .success(let result):
                this.comments[commentIndex].reply = result.replies
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

    func addComment(commentText: String) {
        let comment: Comment = Comment(authorName: Session.shared.userName, commentDisPlay: commentText, authorImageUrl: Session.shared.userImageURL, id: "TM")
        video.comments.insert(comment, at: 0)
    }

    func postComment(commentText: String, completion: @escaping APICompletionFailure) {
        let params = Api.Comment.AllParams(snippet: "snippet", channelId: video.channel?.id ?? "", videoId: video.videoID, textOriginal: commentText, key: App.String.apiKey)
        Api.Comment.postComments(params: params) { (result) in
            switch result {
            case .success:
                self.addComment(commentText: params.textOriginal)
                completion(.success)
            case .failure:
                completion(.failure)
            }
        }
    }

    func handleFavoriteVideo(completion: ReamlCompletion) {
        do {
            let realm = try Realm()
            try realm.write {
                video.isFavorite = !video.isFavorite
                realm.create(Video.self, value: video, update: .modified)
            }
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }

    func loadFavoriteStatus(completion: (Bool) -> Void) {
        do {
            let realm = try Realm()
            let objects = realm.objects(Video.self).filter("videoID = %d AND isFavorite == true", video.videoID)
            if !objects.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            completion(false)
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
