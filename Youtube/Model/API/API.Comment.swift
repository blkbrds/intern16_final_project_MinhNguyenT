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

    struct Result: Mappable {
        var pageToken: String = ""
        var comments: [Comment] = []

        init?(map: Map) { }
        mutating func mapping(map: Map) {
            pageToken <- map["nextPageToken"]
            comments <- map["items"]
        }
    }

    struct AllParams {
        var snippet: String
        var channelId: String
        var videoId: String
        var textOriginal: String
        var key: String
        func toJSON() -> [String: Any] {
            return [
                "part": snippet,
                "channelId": channelId,
                "videoId": videoId,
                "topLevelComment.snippet.textOriginal": textOriginal,
                "key": key
            ]
        }
    }

    @discardableResult
    static func postComments(params: AllParams, completion: @escaping Completion<Result>) -> Request? {
        let path = Api.Path.Comment.comment
        return api.request(method: .post, urlString: path, parameters: params.toJSON(), encoding: JSONEncoding.default, headers: Api.header) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let json):
                    guard let json = json as? JSObject, let result = Mapper<Result>().map(JSON: json) else {
                        completion(.failure(Api.Error.json))
                        return
                    }
                    completion(.success(result))
                }
            }
        }
    }
}
