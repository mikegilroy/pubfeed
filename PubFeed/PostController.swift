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
    static func createPost(location: String, emojis: String, text: String?, photo: String?, bar: Bar, user: User, completion: (post: Post?, error: NSError?) -> Void) {
        // Needs to handle uploading the photo to amazon. This will need correction when the time comes.
        if let userIdentifier = UserController.sharedController.currentUser?.identifier {
            var post = Post(userIdentifier: userIdentifier, barID: bar.barID, timestamp: NSDate(), emojis: emojis, text: text, photo: photo)
            post.save({ (error) -> Void in
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
    static func postFromIdentifier(identifier: String, completion: (post: Post?) -> Void) {
        FirebaseController.dataAtEndpoint("posts/\(identifier)") { (data) -> Void in
            if let data = data as? [String: AnyObject] {
                let post = Post(json: data, identifier: identifier)
                completion(post: post)
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
        
        let like1 = Like(userIdentifier: "sdafsdpfas", postIdentifier: "1234")
        let like2 = Like(userIdentifier: "look", postIdentifier: "4566")
        let like3 = Like(userIdentifier: "em0r0r", postIdentifier: "43212")
        
        let comment1 = Comment(text: "hey", userIdentifier: "123", postIdentifier: "456", timestamp: NSDate())
        let comment2 = Comment(text: "hello", userIdentifier: "abcdef", postIdentifier: "abcd", timestamp: NSDate())
        
        
        let post1 = Post(userIdentifier: "abcdef", barID: "abcdfe", timestamp: NSDate(), emojis: "abcde", text: "abc", photo: sampleImageIdentifier)
        let post2 = Post(userIdentifier: "abcdef", barID: "ab", timestamp: NSDate(), emojis: "hahaha", text: "huhuhu", photo: sampleImageIdentifier)
        
        return [post1, post2]
    }

    
    
    
    
}