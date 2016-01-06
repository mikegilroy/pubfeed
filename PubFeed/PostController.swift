//
//  PostController.swift
//  PubFeedDemoCode
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation

class PostController {
    
    
    // Create
    
    static func createPost(location: String, emojis: String, text: String?, photo: String?, bar: Bar?, user: User, completion: (post: Post?) -> Void) {
        
        //        ImageController.uploadImage(image) { (identifier) -> Void in
        //
        //            if let identifier = identifier {
        //                var post = Post(text: String, photo: identifier, bar: bar, user: user, location: location)
        //                post.save()
        //                completion(post: post)
        //            } else {
        //                completion(post: nil)
        //            }
        //        }
        
    }
    
    
    // Post For Bar
    static func postsForBar(bar: Bar, completion: (posts: [Post]) -> Void) {
        FirebaseController.base.childByAppendingPath("posts").queryOrderedByChild("barID").queryEqualToValue(bar.barID).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let postDictionaries = snapshot.value as? [String: AnyObject] {
                
                let posts = postDictionaries.flatMap({Post(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                
                let orderedPosts = orderPosts(posts)
                
                completion(posts: orderedPosts)
                
            } else {
                
                completion(posts: [])
            }
        })
    }
    
    // Remove
    
    static func deletePost(post: Post, completion: (success: Bool) -> Void) {
        
        post.delete()
        completion(success: true)
    }
    
    static func postFromIdentifier(identifier: String, completion: (post: Post?) -> Void) {
        
        FirebaseController.dataAtEndpoint("posts/\(identifier)") { (data) -> Void in
            
            if let data = data as? [String: AnyObject] {
                let post = Post(json: data, identifier: identifier)
                
                completion(post: post)
            } else {
                completion(post: nil)
            }
        }
    }
    
    static func postsForUser(username: String, completion: (posts: [Post]?) -> Void) {
        FirebaseController.base.childByAppendingPath("posts").queryOrderedByChild("username").queryEqualToValue(username).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let postDictionaries = snapshot.value as? [String: AnyObject] {
                
                let posts = postDictionaries.flatMap({Post(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                
                let orderedPosts = orderPosts(posts)
                
                completion(posts: orderedPosts)
                
            } else {
                
                completion(posts: nil)
            }
        })
        
    }
    
    
    // Sort Post maybe?
    static func orderPosts(posts: [Post]) -> [Post] {
        
        // Sorts posts chronologically using Firebase identifiers
        return posts.sort({$0.0.identifier > $0.1.identifier})
    }
    static func mockPosts() -> [Post] {
        
        let sampleImageIdentifier = "-K1l4125TYvKMc7rcp5e"
        
        let like1 = Like(userIdentifier: "sdafsdpfas", postIdentifier: "1234")
        let like2 = Like(userIdentifier: "look", postIdentifier: "4566")
        let like3 = Like(userIdentifier: "em0r0r", postIdentifier: "43212")
        
        let comment1 = Comment(text: "hola", userIdentifier: "abcdef", postIdentifier: "abc")
        let comment2 = Comment(text: "hello", userIdentifier: "abcdef", postIdentifier: "abcd")
        
        
        let post1 = Post(userIdentifier: "abcdef", barID: "abcdfe", timestamp: NSDate(), emojis: "abcde", text: "abc", photo: sampleImageIdentifier)
        let post2 = Post(userIdentifier: "abcdef", barID: "ab", timestamp: NSDate(), emojis: "hahaha", text: "huhuhu", photo: sampleImageIdentifier)
        
        return [post1, post2]
    }

    
    
    
    
}