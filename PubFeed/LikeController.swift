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
                
//                let base = FirebaseController.base.childByAppendingPath("likes").childByAppendingPath("\(userIdentifier)")
                var like = Like(userIdentifier: userIdentifier, postIdentifier: postIdentifier)
//                base.childByAutoId()
                
//                base.setValue(like as! AnyObject, withCompletionBlock: { (error, base) -> Void in
//                    if error != nil {
//                        completion(like: nil, error: error)
//                    } else {
//                        PostController.incrementLikesOnPost(post, completion: { (post, error) -> Void in
//                            if let error = error {
//                                completion(like: nil, error: error)
//                            } else {
//                                completion(like: like, error: nil)
//                            }
//                        })
//                    }
//                })
          
                
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
    
//    static func likesForPosts(user: User, post: Post, completion: (likes: Like?) -> Void) {
//        FirebaseController.base.childByAppendingPath("likes").queryOrderedByChild("postIdentifier").queryEqualToValue(post.identifier).queryOrderedByChild("userIdentifier").queryEqualToValue(user.identifier).observeSingleEventOfType(.Value) { (snapshot) -> Void in
//            if let like = snapshot.value as? Like {
//                
//            }
//            
//            
//        }
//    }
    static func likesForPost(user: User, post: Post, completion: (likes: [Like]?) -> Void) {
        if let postIdentifier = post.identifier {
            FirebaseController.base.childByAppendingPath("likes").childByAppendingPath(user.identifier).queryOrderedByChild("postIdentifier").queryEqualToValue(postIdentifier).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                
                if let postDictionaries = snapshot.value as? [String: AnyObject] {
                    
//                    let likes = postDictionaries.first
//                    let like = postDictionaries.first! as [String: AnyObject]
                    let likes = postDictionaries.flatMap({Like(json: $0.1 as! [String: AnyObject], identifier: $0.0)})
                    

//                    let comments = commentDictionaries.flatMap({Comment(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
//                    let sortedComments = comments.sort({$0.0.timestamp > $0.1.timestamp})
//                    completion(comments: sortedComments)

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
    
    //UPDATE
    static func toggleLike(like: Like, post: Post, isLiked: Bool, completion: (isLiked: Bool, error: NSError?) -> Void)  {
        //Revisit this after making changes to FirebaseType save and delete functions
        if isLiked == true {
            like.delete({ (error) -> Void in
                if let error = error {
                    completion(isLiked: true, error: error)
                } else {
                    PostController.decrementLikesOnPost(post, completion: { (post, error) -> Void in
                        if let error = error {
                            completion(isLiked: false, error: error)
                        } else {
                            completion(isLiked: false, error: nil)
                        }
                    })
                }
            })
        } else {
            LikeController.addLikeToPost(post, completion: { (like, error) -> Void in
                if let error = error {
                    completion(isLiked: false, error: error)
                } else {
                    PostController.incrementLikesOnPost(post, completion: { (post, error) -> Void in
                        if let error = error {
                            completion(isLiked: true, error: error)
                        } else {
                            completion(isLiked: true, error: nil)
                        }
                    })
                }
            })
        }
    }
    
    // DELETE
    static func deleteAllLikesForPost(post: Post, completion: (error: NSError?) -> Void) {
//        likesForPost(post) { (likes) -> Void in
//            if likes.count > 0 {
//                for like in likes {
//                    like.delete({ (error) -> Void in
//                        if error != nil {
//                            completion(error: error)
//                        }
//                    })
//                }
//            }
//        }
    }
    
    static func deleteAllLikesForUser(user: User, completion: (error: NSError?) -> Void) {
        likesForUser(user) { (likes) -> Void in
            if likes.count > 0 {
                for like in likes {
                    //
                    
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