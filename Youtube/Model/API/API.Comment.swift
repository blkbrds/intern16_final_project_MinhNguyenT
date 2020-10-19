//
//  API.Comment.swift
//  Youtube
//
//  Created by MacBook Pro on 10/8/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

extension Api.Comment {

//    struct Result: Mappable {
//        var pageToken: String = ""
//        var comments: [Comment] = []
//
//        init?(map: Map) { }
//        mutating func mapping(map: Map) {
//            comments <- map["items"]
//        }
//    }

//    struct AllParams {
//        var snippet: String
//        var channelId: String
//        var videoId: String
//        var textOriginal: String
//        func toJSON() -> [String: Any] {
//            return [
//                "part": snippet,
//                "channelId": channelId,
//                "videoId": videoId,
//                "topLevelComment.snippet.textOriginal": textOriginal
//            ]
//        }
//    }

    struct MyParams {
        var channelId: String = ""
        var videoId: String = ""
        var textOriginal: String = ""

        func toJSON() -> [String: Any] {
            let topLevelComment: [String: Any] = [
                "snippet": [
                    "textOriginal": textOriginal
                ]
            ]
            return [
                "snippet": [
                    "channelId": channelId,
                    "videoId": videoId,
                    "topLevelComment": topLevelComment
                ]
            ]
        }
    }

    static func postComments(params: MyParams, completion: @escaping CompletionPost) -> Request? {
        let path = Api.Path.Comment.comment + "?part=snippet"
        return api.request(method: .post, urlString: path, parameters: params.toJSON(), encoding: JSONEncoding.default, headers: Api.header) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
