//
//  API.Home.swift
//  Youtube
//
//  Created by MacBook Pro on 9/28/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Api.Home {

    struct Params {
        var part: String
        var chart: String
        var key: String
        var regionCode: String
        var pageToken: String

        func toJSON() -> [String: Any] {
            return [
                "part": part,
                "chart": chart,
                "key": key,
                "regionCode": regionCode,
                "pageToken": pageToken
            ]
        }
    }

    struct ChannelParams {
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

    struct DurationParams {
        var part: String
        var key: String
        var id: String

        func toJSON() -> [String: Any] {
            return [
                "part": part,
                "key": key,
                "id": id
            ]
        }
    }

    struct Result: Mappable {
        var nextPageToken: String = ""
        var videos: [Video] = []

        init?(map: Map) { }

        mutating func mapping(map: Map) {
            nextPageToken <- map["nextPageToken"]
            videos <- map["items"]
        }
    }

    @discardableResult
    static func getPlaylist(params: Params, completion: @escaping Completion<Result>) -> Request? {
        let path = Api.Path.Home.videoDuration
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    guard let json = json as? JSObject, let result = Mapper<Result>().map(JSON: json) else {
                        completion(.failure(Api.Error.json))
                        return }
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    static func getImageChannel(params: ChannelParams, completion: @escaping Completion<Channel>) -> Request? {
        let path = Api.Path.Home.imageChannel
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    guard let json = json as? JSObject, let items = json["items"] as? JSArray, let channel = Mapper<Channel>().mapArray(JSONArray: items).first else {
                        completion(.failure(Api.Error.json))
                        return }
                    completion(.success(channel))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    static func getVideoDuration(params: DurationParams, completion: @escaping Completion<String>) -> Request? {
        let path = Api.Path.Home.videoDuration
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
