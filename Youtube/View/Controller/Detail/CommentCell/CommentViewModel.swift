//
//  CommentViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 9/30/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation

class CommentViewModel {

    var userReplies: Reply?

    init(replies: Reply? = nil) {
        userReplies = replies
    }
}
