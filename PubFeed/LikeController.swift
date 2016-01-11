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
    static func addLikeToPost(post: Post, completion: (like: Like?, error: NSError?) -> Void) {
        if let userIdentifier = UserController.sharedController.currentUser?.identifier {
            if let postIdentifier = post.identifier {
                var like = Like(userIdentifier: userIdentifier, postIdentifier: postIdentifier)
                like.save({ (error) -> Void in
                    if error != nil {
                        completion(like: nil, error: error)
                    } else {
                        
                        completion(like: like, error: nil)
                    }
                })
            } else {
                completion(like: nil, error: Error.defaultError())
            }
        } else {
            completion(like: nil, error: Error.defaultError())
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
    
    static func likesForBar(bar: Bar, completion: (likes: [Like]) -> Void) {
//        if let barID = bar.barID {
//            FirebaseController.base.childByAppendingPath("likes").childByAppendingPath("barID")
//        }
    }
    
    //UPDATE
    static func toggleLike(like: Like, post: Post, isLiked: Bool, completion: (isLiked: Bool, error: NSError?) -> Void)  {
        //Revisit this after making changes to FirebaseType save and delete functions
        if isLiked == true {
            like.delete({ (error) -> Void in
                if error != nil {
                    completion(isLiked: true, error: error)
                } else {
                    completion(isLiked: false, error: nil)
                }
            })
        } else {
            LikeController.addLikeToPost(post, completion: { (like, error) -> Void in
                if error != nil {
                    completion(isLiked: false, error: error)
                } else {
                    completion(isLiked: true, error: nil)
                }

            })
            
        }
    }
    
    // DELETE
    static func deleteAllLikesForPost(post: Post, completion: (error: NSError?) -> Void) {
        likesForPost(post) { (likes) -> Void in
            if likes.count > 0 {
                for like in likes {
                    like.delete({ (error) -> Void in
                        if error != nil {
                            completion(error: error)
                        }
                    })
                }
            }
        }
    }
    
    static func deleteAllLikesForUser(user: User, completion: (error: NSError?) -> Void) {
        likesForUser(user) { (likes) -> Void in
            if likes.count > 0 {
                for like in likes {
                    like.delete({ (error) -> Void in
                        if error != nil {
                            completion(error: error)
                        }
                    })
                }
            }
        }
    }
    
}