//
//  PostTableViewCell.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    func updateCellWithPost(post: Post) {
        
        self.emojiLabel.text = post.emojis
        
        
        if let postText = post.text {
            self.postTextLabel.text = postText
        } else {
            self.postTextLabel.text = ""
        }
        
        self.timestampLabel.text = post.timestamp.offsetFrom(NSDate())
        
        // Get likes for posts
        self.likeCountLabel.text = "\(post.likes)"
        
        // Get comments for post
        self.commentCountLabel.text = "\(post.comments)"
        
        // Get user for post and set user attributes
        UserController.userWithIdentifier(post.userIdentifier) { (user) -> Void in
            if let user = user {
                    self.usernameLabel.text = user.username
                
                if let userID = user.identifier {
                    ImageController.profilePhotoForIdentifier(userID, completion: { (photoUrl) -> Void in
                        if let photoUrl = photoUrl {
                        ImageController.fetchImageAtUrl(photoUrl, completion: { (image) -> () in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                 self.profileImageView.image = image
                            })
                        })
                        }
                    })
                }
            }
        }
    }
    
    
}
