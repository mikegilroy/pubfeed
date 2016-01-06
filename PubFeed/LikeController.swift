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
}