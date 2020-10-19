//
//  Reply.swift
//  Youtube
//
//  Created by MacBook Pro on 10/13/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import ObjectMapper

class Reply: Mappable {

    var id: String = ""
    var publishedAt: String = ""
    var authorName: String = ""
    var authorImageUrl: String = ""
    var textOriginal: String = ""

    init(authorName: String, textOriginal: String, authorImageUrl: String, id: String) {
        self.id = id
        self.authorImageUrl = authorImageUrl
        self.authorName = authorName
        self.textOriginal = textOriginal
    }

    required init() { }

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        publishedAt <- map["snippet.publishedAt"]
        authorName <- map["snippet.authorDisplayName"]
        authorImageUrl <- map["snippet.authorProfileImageUrl"]
        textOriginal <- map["snippet.textOriginal"]
    }
}
