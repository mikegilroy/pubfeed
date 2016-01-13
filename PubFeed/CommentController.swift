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
    static func addCommentToPost(post: Post, text: String, completion: (comment: Comment?, error: NSError?) -> Void) {
        if let currentUser = UserController.sharedController.currentUser {
            if let postIdentifier = post.identifier {
                var comment = Comment(username: currentUser.username, text: text, userIdentifier: currentUser.identifier!, userPhotoUrl: currentUser.photo, postIdentifier: postIdentifier, timestamp: NSDate())
                comment.save({ (error) -> Void in
                    if let error = error {
                        completion(comment: nil, error: error)
                    } else {
                        PostController.incrementCommentsOnPost(post, completion: { (post, error) -> Void in
                            if let error = error {
                                completion(comment: nil, error: error)
                            } else {
                                completion(comment: comment, error: nil)
                            }
                        })
                    }
                })
            } else {
                completion(comment: nil, error: Error.defaultError())
            }
        } else {
            completion(comment: nil, error: Error.defaultError())
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
    static func deleteComment(post: Post, comment: Comment, completion: (error: NSError?) -> Void) {
        comment.delete { (error) -> Void in
            if let error = error {
                completion(error: error)
            } else {
                PostController.decrementCommentsOnPost(post, completion: { (post, error) -> Void in
                    if let error = error {
                        completion(error: error)
                    } else {
                        completion(error: nil)
                    }
                })
            }
        }
    }
    
    static func deleteAllCommentsForPost(post: Post, completion: (error: NSError?) -> Void) {
        commentsForPost(post) { (comments) -> Void in
            if comments.count > 0 {
                for comment in comments {
                    comment.delete({ (error) -> Void in
                        if error != nil {
                            completion(error: error)
                        }
                    })
                }
            }
        }
    }
    
    static func deleteAllCommentsForUser(user: User, completion: (error: NSError?) -> Void) {
        commentsForUser(user) { (comments) -> Void in
            if comments.count > 0 {
                for comment in comments {
                    comment.delete({ (error) -> Void in
                        if error != nil {
                            completion(error: error)
                        }
                    })
                }
            }
        }
    }
    
}