//
//  LikeController.swift
//  PubFeedDemoCode
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation

class LikeController {

    // CREATE
    static func addLikeToPost(post: Post) {
        if let userIdentifier = UserController.sharedController.currentUser?.identifier {
            if let postIdentifier = post.identifier {
                var like = Like(userIdentifier: userIdentifier, postIdentifier: postIdentifier)
                like.save()
            }
        }
    }
    
    // READ
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
    
    //UPDATE
    static func toggleLike(like: Like, post: Post, isLiked: Bool, completion: (isLiked: Bool) -> Void)  {
        //Revisit this after making changes to FirebaseType save and delete functions
        if isLiked == true {
            LikeController.deleteLike(like)
            completion(isLiked: false)
            
        } else {
            LikeController.addLikeToPost(post)
            completion(isLiked: true)
        }
    }

    
    // DELETE
    static func deleteLike(like: Like) {
        like.delete()
    }
}