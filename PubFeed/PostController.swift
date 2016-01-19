//
//  PostController.swift
//  PubFeedDemoCode
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation

class PostController {
    
    
    // CREATE
    static func createPost(location: CLLocation, emojis: String, text: String?, photo: String?, bar: Bar, user: User, completion: (post: Post?, error: NSError?) -> Void) {
        // Needs to handle uploading the photo to amazon. This will need correction when the time comes.
        if let userIdentifier = UserController.sharedController.currentUser?.identifier {
            var post = Post(userIdentifier: userIdentifier, barID: bar.barID, timestamp: NSDate(), emojis: emojis, text: text, photo: photo, likes: 0, comments: 0, latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude))
            post.saveWithLocation(location, completion: { (error) -> Void in
                if error != nil {
                    completion(post: nil, error: error)
                } else {
                    completion(post: post, error: nil)
                }
            })
        } else {
            completion(post: nil, error: Error.defaultError())
        }
        
    }
    
    // READ
    static func postsForLocation(location: CLLocation, radius: Double, completion: (posts: [Post]?, error: NSError?) -> Void) {
        var posts: [Post] = []
        let locationBase = FirebaseController.base.childByAppendingPath("posts")
        let geoFire = GeoFire(firebaseRef: locationBase)
        let circleQuery = geoFire.queryAtLocation(location, withRadius: radius)
        circleQuery.observeSingleEventOfTypeValue({ (json) -> Void in
            let keys = Array(json.keys)
            if keys.count > 0 {
                for key in keys {
                    if let identifier = key as? String {
                        postFromIdentifier(identifier, completion: { (post) -> Void in
                            if let post = post {
                                posts.append(post)
                                if posts.count == keys.count {
                                    let sortedPosts = posts.sort({ (post1, post2) -> Bool in
                                        post1.barID < post2.barID
                                    })
                                    completion(posts: sortedPosts, error: nil)
                                }
                            } else {
                                completion(posts: nil, error: Error.defaultError())
                            }
                        })
                    } else {
                        completion(posts: nil, error: Error.defaultError())
                    }
                }
            } else {
                completion(posts: [], error: nil)
            }
        })
    }
    
    static func postFromIdentifier(identifier: String, completion: (post: Post?) -> Void) {
        FirebaseController.dataAtEndpoint("posts/\(identifier)") { (data) -> Void in
            if let data = data as? [String: AnyObject] {
                let post = Post(json: data, identifier: identifier)
                completion(post: post)
            }
        }
    }
    
    static func incrementLikesOnPost(post: Post, completion: (post: Post?, error: NSError?) -> Void) {
        let likes = post.likes + 1
        
        var updatedPost = Post(userIdentifier: post.userIdentifier, barID: post.barID, timestamp: post.timestamp, emojis: post.emojis, text: post.text, photo: post.photo, identifier: post.identifier, likes: likes, comments: post.comments, latitude: post.latitude, longitude: post.longitude)
        
        updatedPost.save { (error) -> Void in
            if error != nil {
                completion(post: nil, error: error)
            } else {
                completion(post: updatedPost, error: nil)
            }
        }
    }
    
    
    static func decrementLikesOnPost(post: Post, completion: (post: Post?, error: NSError?) -> Void) {
        if post.likes > 0 {
            let likes = post.likes - 1
            
            var updatedPost = Post(userIdentifier: post.userIdentifier, barID: post.barID, timestamp: post.timestamp, emojis: post.emojis, text: post.text, photo: post.photo, identifier: post.identifier, likes: likes, comments: post.comments, latitude: post.latitude, longitude: post.longitude)
            
            updatedPost.save { (error) -> Void in
                if error != nil {
                    completion(post: nil, error: error)
                } else {
                    completion(post: updatedPost, error: nil)
                }
            }
        }
    }
    
    
    static func incrementCommentsOnPost(post: Post, completion: (post: Post?, error: NSError?) -> Void) {
        let comments = post.comments + 1
        
        var updatedPost = Post(userIdentifier: post.userIdentifier, barID: post.barID, timestamp: post.timestamp, emojis: post.emojis, text: post.text, photo: post.photo, identifier: post.identifier, likes: post.likes, comments: comments, latitude: post.latitude, longitude: post.longitude)
        
        updatedPost.save { (error) -> Void in
            if error != nil {
                completion(post: nil, error: error)
            } else {
                completion(post: updatedPost, error: nil)
            }
        }
    }
    
    
    static func decrementCommentsOnPost(post: Post, completion: (post: Post?, error: NSError?) -> Void) {
        if post.comments > 0 {
            let comments = post.comments - 1
            
            var updatedPost = Post(userIdentifier: post.userIdentifier, barID: post.barID, timestamp: post.timestamp, emojis: post.emojis, text: post.text, photo: post.photo, identifier: post.identifier, likes: post.likes, comments: comments, latitude: post.latitude, longitude: post.longitude)
            
            updatedPost.save { (error) -> Void in
                if error != nil {
                    completion(post: nil, error: error)
                } else {
                    completion(post: updatedPost, error: nil)
                }
            }
        }
    }
    
    static func postsForBar(bar: Bar, completion: (posts: [Post]) -> Void) {
        FirebaseController.base.childByAppendingPath("posts").queryOrderedByChild("barID").queryEqualToValue(bar.barID).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let postDictionaries = snapshot.value as? [String: AnyObject] {
                let posts = postDictionaries.flatMap({Post(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                
                let orderedPosts = posts.sort({$0.0.timestamp > $0.1.timestamp})
                completion(posts: orderedPosts)
            } else {
                completion(posts: [])
            }
        })
    }
    
    static func postsForUser(user: User, completion: (posts: [Post]) -> Void) {
        if let userIdentifier = user.identifier {
            FirebaseController.base.childByAppendingPath("posts").queryOrderedByChild("userIdentifier").queryEqualToValue(userIdentifier).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                if let postDictionaries = snapshot.value as? [String: AnyObject] {
                    let posts = postDictionaries.flatMap({Post(json: $0.1 as! [String: AnyObject], identifier: $0.0)})
                    completion(posts: posts)
                } else {
                    completion(posts: [])
                }
            })
        }
    }
    
    // Remove
    static func deletePost(post: Post, completion: (errors: [NSError]?) -> Void) {
        var errorArray: [NSError] = []
        CommentController.deleteAllCommentsForPost(post, completion: { (error) -> Void in
            if let error = error {
                errorArray.append(error)
            }
        })
        //        LikeController.deleteAllLikesForPost(post, completion: { (error) -> Void in
        //            if let error = error {
        //                errorArray.append(error)
        //            }
        //        })
        post.delete { (error) -> Void in
            if let error = error {
                errorArray.append(error)
            }
        }
        if errorArray.count == 0 {
            completion(errors: nil)
        } else {
            completion(errors: errorArray)
        }
    }
    
    static func reportPost(user: User, post: Post, text: String, completion: (success: Bool) -> Void) {
        
        let base = FirebaseController.base.childByAppendingPath("report").childByAppendingPath("\(user.identifier!)").childByAutoId()
        print(post.identifier)
        
        let post = ["postIdentifier": post.identifier!, "reason": text]
        base.setValue(post)
        
        completion(success: true)
    }
    
    static func queryReport(user: User, post: Post, completion: (post: Post?) -> Void) {
        FirebaseController.base.childByAppendingPath("report").childByAppendingPath(user.identifier).queryOrderedByChild("postIdentifier").observeEventType(.ChildAdded, withBlock: {snapshot in
            
            if let postID = snapshot.value["postIdentifier"] as? String {
                PostController.postFromIdentifier(postID, completion: { (post) -> Void in
                    if let post = post {
                        completion(post: post)
                    } else {
                        completion(post: nil)
                    }
                })
            } else {
                completion(post: nil)
            }
            }
        )
    }
    
    
    static func deleteAllPostsForUser(user: User, completion: (errors: [NSError]?) -> Void) {
        postsForUser(user) { (posts) -> Void in
            if posts.count > 0 {
                for post in posts {
                    deletePost(post, completion: { (errors) -> Void in
                        if let errors = errors {
                            completion(errors: errors)
                        }
                    })
                }
            }
        }
    }
}