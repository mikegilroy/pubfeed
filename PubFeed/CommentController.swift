//
//  CommentController.swift
//  PubFeedDemoCode
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation

class CommentController {
    
    // CREATE
    static func addCommentToPost(post: Post, text: String, completion: (comment: Comment?) -> Void?) {
        if let userIdentifier = UserController.sharedController.currentUser?.identifier {
            if let postIdentifier = post.identifier {
            var comment = Comment(text: text, userIdentifier: userIdentifier, postIdentifier: postIdentifier, timestamp: NSDate())
                comment.save()
            }
        }
    }
    
    // READ
    static func commentsForPost(post: Post, completion: (comments: [Comment]) -> Void) {
        if let postIdentifier = post.identifier {
            
            FirebaseController.base.childByAppendingPath("comments").childByAppendingPath("postIdentifier").queryEqualToValue(postIdentifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let commentDictionaries = snapshot.value as? [String:AnyObject] {
                    
                    let comments = commentDictionaries.flatMap({Comment(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                    let sortedComments = comments.sort({$0.0.timestamp > $0.1.timestamp})
                    
                    completion(comments: sortedComments)
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
    
    // DELETE
    static func deleteComment(comment: Comment, completion: (success: Bool, post: Post?) -> Void) {
        
        comment.delete()
        PostController.postFromIdentifier(comment.postIdentifier) { (post) -> Void in
            completion(success: true, post: post)
        }
    }
    
    

    
}