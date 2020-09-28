//
//  HomeCellViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 9/21/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation

final class HomeCellViewModel {
    private(set) var imageChannelURL: String = ""
    private(set) var video: Video?
    private(set) var duration: String?

    init(video: Video? = nil) {
        self.video = video
        self.duration = video?.duration
        if let imgChannel = video?.imageURL {
            imageChannelURL = imgChannel
        }
    }

    func loadImageChannel(completion: @escaping APICompletion) {
        guard let video = video, let id = video.channel?.id, !video.isLoadApiCompleted else {
            return
        }
        let params = Api.Home.ChannelParams(part: "snippet", id: id, key: App.String.apiKey)
        Api.Home.getImageChannel(params: params) { [weak self] (result) in
            guard let this = self else {
                return
            }
            switch result {
            case .success(let imageChannel):
                this.video?.isLoadApiCompleted = true
                this.imageChannelURL = imageChannel.imageURL
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
