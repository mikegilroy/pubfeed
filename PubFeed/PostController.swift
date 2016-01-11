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
            var post = Post(userIdentifier: userIdentifier, barID: bar.barID, timestamp: NSDate(), emojis: emojis, text: text, photo: photo, likes: 0, comments: 0)
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
            for key in keys {
                if let identifier = key as? String {
                    postFromIdentifier(identifier, completion: { (post) -> Void in
                        if let post = post {
                            posts.append(post)
                            if posts.count == keys.count {
                                completion(posts: posts, error: nil)
                            }
                        } else {
                            completion(posts: nil, error: Error.defaultError())
                        }
                    })
                } else {
                    completion(posts: nil, error: Error.defaultError())
                }
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
    
    static func incrementLikesOnPost(post: Post, completion: (post: Post?) -> Void) {
        let likes = post.likes + 1
        
        if let identifier = post.identifier {
            FirebaseController.dataAtEndpoint("posts/\(identifier)/l", completion: { (data) -> Void in
                print(data)
                if let data = data as? [Int: Double] {
                    let latitude = data[0]
                    let longitude = data[1]
                    let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                    
                    var updatedPost = Post(userIdentifier: post.userIdentifier, barID: post.barID, timestamp: post.timestamp, emojis: post.emojis, text: post.text, photo: post.photo, likes: likes, comments: post.comments)
                    
                }
            })
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
        LikeController.deleteAllLikesForPost(post, completion: { (error) -> Void in
            if let error = error {
                errorArray.append(error)
            }
        })
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
        
    
    static func mockPosts() -> [Post] {
        
        let sampleImageIdentifier = "-K1l4125TYvKMc7rcp5e"
        
        let post1 = Post(userIdentifier: "abcdef", barID: "abcdfe", timestamp: NSDate(), emojis: "abcde", text: "abc", photo: sampleImageIdentifier, likes: 1, comments: 2)
        let post2 = Post(userIdentifier: "abcdef", barID: "ab", timestamp: NSDate(), emojis: "hahaha", text: "huhuhu", photo: sampleImageIdentifier, likes: 12, comments: 1)
        
        return [post1, post2]
    }

    
    
    
    
}