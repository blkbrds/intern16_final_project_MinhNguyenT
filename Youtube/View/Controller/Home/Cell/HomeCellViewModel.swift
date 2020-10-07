//
//  HomeCellViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 9/21/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation

final class HomeCellViewModel {

    private(set) var video: Video?
    private(set) var indexPath: IndexPath?

    init(video: Video? = nil, indexPath: IndexPath? = nil) {
        self.video = video
    }

    func getChannelImage(completion: @escaping APICompletion) {
        guard let video = video, let id = video.channel?.id, !video.isLoadImageChannelCompleted else {
            return
        }
        let params = Api.Home.ChannelParams(part: "snippet", id: id, key: App.String.apiKey)
        Api.Home.getImageChannel(params: params) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let imageChannel):
                this.video?.isLoadImageChannelCompleted = true
                this.video?.imageChannelURL = imageChannel.imageURL
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
