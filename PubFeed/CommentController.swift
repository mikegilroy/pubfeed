//
//  CommentController.swift
//  PubFeedDemoCode
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation

class CommentController {
    
    
    static func addCommentWithTextToPost(text: String, post: Post, completion: (success: Bool, post: Post?) -> Void?) {
        
        var comment = Comment(text: text, userIdentifier: UserController.sharedController.currentUser.identifier!, postIdentifier: post.identifier!)
        
        comment.save()
        
        PostController.postFromIdentifier(comment.postIdentifier) { (post) -> Void in
            completion(success: true, post: post)
        }
    }
    
    
    static func deleteComment(comment: Comment, completion: (success: Bool, post: Post?) -> Void) {
        
        comment.delete()
        PostController.postFromIdentifier(comment.postIdentifier) { (post) -> Void in
            completion(success: true, post: post)
        }
    }
    
}