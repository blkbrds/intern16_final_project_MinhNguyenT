//
//  Channel.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers class Channel: Object, Mappable {
    dynamic var id: String = ""
    var imageURL: String = ""
    dynamic var title: String = ""
    var subscriberCount: String = ""

    required init() { }

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        title <- map["snippet.title"]
        imageURL <- map["snippet.thumbnails.default.url"]
        subscriberCount <- map["statistics.subscriberCount"]
    }

    override static func primaryKey() -> String? {
           return "id"
    }
}
