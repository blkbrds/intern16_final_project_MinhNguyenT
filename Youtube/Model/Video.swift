//
//  Video.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import ObjectMapper

class Video: Mappable {
    var videoID: String = ""
    var imageURL: String = ""
    var title: String = ""
    var channel: Channel?
    var viewCount: String = ""
    var likeCount: String = ""
    var dislikeCount: String = ""
    var comments: [Comment] = []
    var commentCount: String = ""
    var duration: String?
    var createdTime: String = ""
    var isLoadApiCompleted: Bool = false

    required init() { }

    required init?(map: Map) { }

    func mapping(map: Map) {
        var tempId: String = ""
        tempId <- map["id.videoId"]
        if tempId.isEmpty {
            tempId <- map["id"]
        }
        videoID = tempId
        imageURL <- map["snippet.thumbnails.high.url"]
        title <- map["snippet.title"]
        let channel = Channel()
        channel.id <- map["snippet.channelId"]
        channel.title <- map["snippet.channelTitle"]
        self.channel = channel
        viewCount <- map["statistics.viewCount"]
        likeCount <- map["statistics.likeCount"]
        dislikeCount <- map["statistics.dislikeCount"]
        commentCount <- map["statistics.commentCount"]
        createdTime <- map["snippet.publishedAt"]

    }
}

extension Video: Equatable {
    static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.videoID == rhs.videoID
    }
}
