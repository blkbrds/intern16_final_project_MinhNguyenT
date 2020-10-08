//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation
import Alamofire

final class Api {

    static var header: [String: String] = ["Authorization": "Bearer \(Session.shared.userAcccessToken)",
    "Accept": "application/json",
    "Content-Type": "application/json"]

    struct Path {
        static let baseURL = "https://www.googleapis.com/youtube/v3"
    }

    struct Home { }
    struct Detail { }
    struct Comment { }
}

extension Api.Path {
    struct Home {
        static var path: String {
            return baseURL / "search"
        }

        static var videoDuration: String {
            return baseURL / "videos"
        }

        static var imageChannel: String {
            return baseURL / "channels"
        }
    }

    struct Detail {
        static var videos: String {
            return baseURL / "videos"
        }

        static var comment: String {
            return baseURL / "commentThreads"
        }

        static var videoChannel: String {
            return baseURL / "channels"
        }
    }

    struct Comment {
        static var comment: String {
            return baseURL / "commentThreads"
        }
    }
}
protocol URLStringConvertible {
    var urlString: String { get }
}

protocol ApiPath: URLStringConvertible {
    static var path: String { get }
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
    return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
    var urlString: String { return self }
}

private func / (left: String, right: Int) -> String {
    return left.appending(path: "\(right)")
}
