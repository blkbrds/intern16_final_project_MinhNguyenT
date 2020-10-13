//
//  Comment.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable {

    var id: String = ""
    var publishedAt: Date = Date()
    var authorName: String = ""
    var authorImageUrl: String = ""
    var commentDisplay: String = ""
    var textOriginal: String = ""

    init(authorName: String, commentDisPlay: String, authorImageUrl: String, id: String) {
        self.id = id
        self.authorImageUrl = authorImageUrl
        self.authorName = authorName
        self.commentDisplay = commentDisPlay
    }

    required init() { }

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        publishedAt <- map["snippet.topLevelComment.snippet.publishedAt"]
        authorName <- map["snippet.topLevelComment.snippet.authorDisplayName"]
        authorImageUrl <- map["snippet.topLevelComment.snippet.authorProfileImageUrl"]
        commentDisplay <- map["snippet.topLevelComment.snippet.textDisplay"]
        textOriginal <- map["snippet.topLevelComment.snippet.textOriginal"]
    }
}
