//
//  LikeController.swift
//  PubFeedDemoCode
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation

class LikeController {
    

    static func toggleLike(like: Like, post: Post, completion: (success: Bool, post: Post) -> Void)  {
        let isLiked: Bool = false
        
        if isLiked == true {
            LikeController.deleteLike(like)
            completion(success: true, post: post)
            
        } else {
            LikeController.addLikeToPost(post)
            completion(success: true, post: post)
        }
        PostController.postFromIdentifier(post.identifier!, completion: { (post) -> Void in
            completion(success: true, post: post!)
        })
    }
    
    
    static func addLikeToPost(post: Post) {
        
        var like = Like(userIdentifier: UserController.sharedController.currentUser.identifier!, postIdentifier: post.identifier!)
        like.save()
    }
    
    
    static func deleteLike(like: Like) {
        like.delete()
    }
    
    
    static func likesForUser(user: User, completion: (likes: [Like]) -> Void) {
        if let userIdentifier = user.identifier {
            
            FirebaseController.base.childByAppendingPath("likes").childByAppendingPath("userIdentifier").queryEqualToValue(userIdentifier).observeEventType(.Value, withBlock: {
                snapshot in
                
                if let likeDictionaries = snapshot.value as? [String:AnyObject] {
                    
                    let likes = likeDictionaries.flatMap({Like(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                    
                    completion(likes: likes)
                } else {
                    completion(likes: [])
                }
            })
        }
    }
    
    
    static func likesForPost(post: Post, completion: (likes: [Like]) -> Void) {
        if let postIdentifier = post.identifier {
            
            FirebaseController.base.childByAppendingPath("likes").childByAppendingPath("postIdentifier").queryEqualToValue(postIdentifier).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                
                if let postDictionaries = snapshot.value as? [String:AnyObject] {
                    
                    let likes = postDictionaries.flatMap({Like(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                    
                    completion(likes: likes)
                } else {
                    completion(likes: [])
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