//
//  RepliesViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 10/15/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation

final class RepliesViewModel {

    var comment: Comment
    var reply: [Reply] = []
    private var nextPageToken: String = ""
    var isLoading: Bool = false

    init(comment: Comment = Comment()) {
        self.comment = comment
    }

    func numberOfItems(inSection section: Int) -> Int {
        return reply.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> CommentViewModel {
        return CommentViewModel(replies: reply[indexPath.row])
    }

    func loadApiReply(isLoadMore: Bool, completion: @escaping APICompletion) {
        guard !isLoading else { return }
        if !isLoadMore {
            nextPageToken = ""
        }
        isLoading = true
        let params = Api.Detail.ReplyParams(part: "snippet", parentId: comment.id, key: App.String.apiKey, maxResults: 20, pageToken: nextPageToken)
        Api.Detail.getReply(params: params) { [weak self] (result) in
            guard let this = self else { return }
            this.isLoading = false
            switch result {
            case .success(let result):
                if isLoadMore {
                    this.reply.append(contentsOf: result.replies)
                } else {
                    this.reply = result.replies
                }
                this.nextPageToken = result.pageToken
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
