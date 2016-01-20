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
                        
                        PostController.incrementLikesOnPost(post, completion: { (post, error) -> Void in
                            if let error = error {
                                completion(like: nil, error: error)
                            } else {
                                completion(like: like, error: nil)
                            }
                        })
                    }
                })
            } else {
                completion(like: nil, error: Error.defaultError())
            }
        } else {
            completion(like: nil, error: Error.defaultError())
        }
    }
    
    static func deleteLike(like: Like, post: Post, completion: (success: Bool, post: Post?, error: NSError?) -> Void) {
        like.delete { (error) -> Void in
            if let error = error {
                completion(success: false, post: nil, error: error)
            } else {
                
                PostController.decrementLikesOnPost(post, completion: { (post, error) -> Void in
                    if error == nil {
                        completion(success: true, post: post, error: nil)
                    } else {
                        completion(success: false, post: nil, error: error)
                    }
                })
                
                PostController.postFromIdentifier(like.postIdentifier) { (post) -> Void in
                    completion(success: true, post: post, error: nil)
                }
            }
        }
    }
    
    // READ
    static func likesForUser(user: User, completion: (likes: [Like]) -> Void) {
        if let userIdentifier = user.identifier {
            FirebaseController.base.childByAppendingPath("likes").queryOrderedByChild("userIdentifier").queryEqualToValue(userIdentifier).observeEventType(.Value, withBlock: {
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

    static func likesForPost(user: User, post: Post, completion: (likes: [Like]?) -> Void) {
        if let postIdentifier = post.identifier {
            FirebaseController.base.childByAppendingPath("likes").childByAppendingPath(user.identifier).queryOrderedByChild("postIdentifier").queryEqualToValue(postIdentifier).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                
                if let postDictionaries = snapshot.value as? [String: AnyObject] {
                    
    
                    let likes = postDictionaries.flatMap({Like(json: $0.1 as! [String: AnyObject], identifier: $0.0)})
                    
                    completion(likes: likes)
                } else {
                    completion(likes: nil)
                }
            })
        }
    }
    
    static func likesForBar(bar: Bar, completion: (likes: [Like]) -> Void) {
        //        if let barID = bar.barID {
        //            FirebaseController.base.childByAppendingPath("likes").childByAppendingPath("barID")
        //        }
    }
    
    static func deleteAllLikesForUser(user: User, completion: (error: NSError?) -> Void) {
        likesForUser(user) { (var likes) -> Void in
            if likes.count > 0 {
                likes.removeAll()
            }
        }
    }
    
}