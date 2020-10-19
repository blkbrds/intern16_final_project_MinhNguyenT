//
//  CommentHeaderViewModel.swift
//  Youtube
//
//  Created by MacBook Pro on 10/14/20.
//  Copyright © 2020 Minh Nguyen T. All rights reserved.
//

import Foundation

final class CommentHeaderViewModel {

     var userComment: Comment?

     init(comment: Comment? = nil) {
         userComment = comment
     }
}
