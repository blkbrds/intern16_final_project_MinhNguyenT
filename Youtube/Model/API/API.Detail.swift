//
//  API.Detail.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

extension Api.Detail {

    struct CommentParams {
        var part: String
        var videoId: String
        var key: String
        var maxResults: Int
        var pageToken: String

        func toJSON() -> [String: Any] {
            return [
                "part": part,
                "videoId": videoId,
                "key": key,
                "maxResults": maxResults,
                "pageToken": pageToken
            ]
        }
    }

    struct ReplyParams {
        var part: String
        var parentId: String
        var key: String
        var maxResults: Int
        var pageToken: String

        func toJSON() -> [String: Any] {
            return [
                "part": part,
                "parentId": parentId,
                "key": key,
                "maxResults": maxResults,
                "pageToken": pageToken
            ]
        }
    }

    struct Result: Mappable {
        var pageToken: String = ""
        var comments: [Comment] = []

        init?(map: Map) { }
        mutating func mapping(map: Map) {
            pageToken <- map["nextPageToken"]
            comments <- map["items"]
        }
    }

    struct ResultReply: Mappable {
        var pageToken: String = ""
        var replies: [Reply] = []

        init?(map: Map) { }
        mutating func mapping(map: Map) {
            pageToken <- map["nextPageToken"]
            replies <- map["items"]
        }
    }

    struct VideoDetailParams {
        var part: String
        var id: String
        var key: String

        func toJSON() -> [String: Any] {
            return [
                "part": part,
                "id": id,
                "key": key
            ]
        }
    }

    struct VideoChannelParams {
        var part: String
        var key: String
        var id: String

        func toJSON() -> [String: Any] {
            return [
                "part": part,
                "id": id,
                "key": key
            ]
        }
    }

    @discardableResult
    static func getComments(params: CommentParams, completion: @escaping Completion<Result>) -> Request? {
        let path = Api.Path.Detail.comment
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    guard let json = json as? JSObject, let result = Mapper<Result>().map(JSON: json) else {
                        completion(.failure(Api.Error.json))
                        return
                    }
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    static func getReply(params: ReplyParams, completion: @escaping Completion<ResultReply>) -> Request? {
        let path = Api.Path.Detail.reply
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    guard let json = json as? JSObject, let result = Mapper<ResultReply>().map(JSON: json) else {
                        completion(.failure(Api.Error.json))
                        return
                    }
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    static func getVideoDetail(params: VideoDetailParams, completion: @escaping Completion<Video>) -> Request? {
        let path = Api.Path.Detail.videos
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    guard let json = json as? JSObject, let items = json["items"] as? JSArray, let video = Mapper<Video>().mapArray(JSONArray: items).first else {
                        completion(.failure(Api.Error.json))
                        return }
                    video.videoID = params.id
                    completion(.success(video))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    static func getVideoChannel(params: VideoChannelParams, completion: @escaping Completion<Channel?>) -> Request? {
        let path = Api.Path.Detail.videoChannel
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    guard let json = json as? JSObject, let items = json["items"] as? JSArray else {
                        completion(.failure(Api.Error.json))
                        return }
                    let channel = Mapper<Channel>().mapArray(JSONArray: items).first
                    completion(.success(channel))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    static func getVideoDuration(params: VideoDetailParams, completion: @escaping Completion<String>) -> Request? {
        let path = Api.Path.Detail.videos
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    guard let json = json as? JSObject,
                        let items = json["items"] as? JSArray,
                        let item = items.first,
                        let contentDetails = item["contentDetails"] as? JSObject,
                        let duration = contentDetails["duration"] as? String
                        else {
                            completion(.failure(Api.Error.json))
                            return
                    }
                    completion(.success(duration))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
