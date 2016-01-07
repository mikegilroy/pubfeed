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
    
    
    static func commentsForPost(post: Post, completion: (comments: [Comment]) -> Void) {
        if let postIdentifier = post.identifier {
            
            FirebaseController.base.childByAppendingPath("comments").childByAppendingPath("postIdentifier").queryEqualToValue(postIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let commentDictionaries = snapshot.value as? [String:AnyObject] {
                    
                    let comments = commentDictionaries.flatMap({Comment(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                    
                    completion(comments: comments)
                } else {
                    completion(comments: [])
                }
            })
        }
        
    }
    
    
    static func commentsForUser(user:User, completion: (comments: [Comment]) -> Void) {
        if let userIdentifier = user.identifier {
            FirebaseController.base.childByAppendingPath("comments").childByAppendingPath("userIdentifier").queryEqualToValue(userIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let commentDictionaries = snapshot.value as? [String:AnyObject] {
                    
                    let comments  = commentDictionaries.flatMap({Comment(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                    
                    completion(comments: comments)
                } else {
                    completion(comments: [])
                }
            })
        }
        
    }
    
}