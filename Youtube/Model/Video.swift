//
//  Video.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers final class Video: Object, Mappable {
    dynamic var videoID: String = ""
    dynamic var imageURL: String = ""
    dynamic var title: String = ""
    dynamic var channel: Channel?
    var viewCount: String = ""
    var likeCount: String = ""
    var dislikeCount: String = ""
    var comments: [Comment] = []
    var commentCount: String = ""
    dynamic var duration: String = ""
    var createdTime: String = ""
    var isLoadImageChannelCompleted: Bool = false
    var imageChannelURL: String = ""
    dynamic var isFavorite: Bool = false

    required init() { }

    init(videoId: String, imageURL: String, title: String, channelTitle: String, durationTime: String, isFavorite: Bool) {
        self.videoID = videoId
        self.title = title
        self.channel?.title = channelTitle
        self.duration = durationTime
        self.isFavorite = isFavorite
    }

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

    override static func primaryKey() -> String? {
        return "videoID"
    }

    override class func ignoredProperties() -> [String] {
        return ["comments", "viewCount", "likeCount", "dislikeCount", "commentCount", "createdTime", "isLoadImageChannelCompleted", "imageChannelURL"]
    }
}
//extension Video: Equatable {
//    static func == (lhs: Video, rhs: Video) -> Bool {
//        return lhs.videoID == rhs.videoID
//    }
//}
