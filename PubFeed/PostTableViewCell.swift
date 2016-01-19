//
//  PostTableViewCell.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate {
    func likeButtonTapped(sender: PostTableViewCell)
    func reportButtonTapped(sender: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    // Properties
    
    var delegate: PostTableViewCellDelegate?
    
    // Outlets
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    
    func updateCellWithPost(post: Post) {
        //self.addCustomSeperator(UIColor.lightGrayColor())
        
        self.emojiLabel.text = post.emojis
        
        if let postText = post.text {
            self.postTextLabel.text = postText
        } else {
            self.postTextLabel.text = ""
        }
        postTextLabel.lineBreakMode = .ByWordWrapping
        
        self.timestampLabel.text = "\(post.timestamp.offsetFrom(NSDate()))"
        print(post.timestamp)
        
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
                                    if let image = image {
                                        self.profileImageView.image = image
                                    } else {
                                        self.profileImageView.image = UIImage(named: "defaultProfilePhoto")
                                    }
                                })
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.profileImageView.image = UIImage(named: "defaultProfilePhoto")
                            })
                        }
                    })
                } else {
                    self.profileImageView.image = UIImage(named: "defaultProfilePhoto")
                }
            } else {
                self.profileImageView.image = UIImage(named: "defaultProfilePhoto")
            }
        }
        
        self.profileImageView.layer.cornerRadius = 15
        self.profileImageView.layer.borderColor = UIColor.blackColor().CGColor
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.clipsToBounds = true
        
        if let imageString = post.photo {
            if let imageURL = NSURL(string: imageString) {
                ImageController.fetchImageAtUrl(imageURL, completion: { (image) -> () in
                    if let image = image {
                    self.postImageView.image = image
                    // imageview width = screenwidth - 64
                    let imageViewWidth = self.frame.width - 64
                    let imageWidth = image.size.width
                    let ratio = imageWidth / imageViewWidth
                    let imageViewHeight = image.size.height / ratio
                    
                    self.postImageView.frame = CGRect(x: self.postImageView.frame.origin.x, y: self.postImageView.frame.origin.y, width: imageViewWidth, height: imageViewHeight)
                    }
                })
            } else {
                self.postImageView.frame = CGRect(x: self.postImageView.frame.origin.x, y: self.postImageView.frame.origin.y, width: 0, height: 0)
            }
        } else {
            if let image = postImageView.image {
                addImageHeightConstraint(image)
            }
        }
    }
    
    func updateLikeButton(post: Post) {
        LikeController.likesForPost(UserController.sharedController.currentUser!, post: post) { (likes) -> Void in
            if let _ = likes {
                self.likeButton.setBackgroundImage(UIImage(named: "DARKbeers"), forState: .Normal)
            } else {
                self.likeButton.setBackgroundImage(UIImage(named: "heartIconGrey"), forState: .Normal)
            }
        }
    }

    @IBAction func reportButtonTapped(sender: PostTableViewCell) {
        self.delegate?.reportButtonTapped(sender)
    }

    
    @IBAction func likeButtonTapped(sender: PostTableViewCell) {
        self.delegate?.likeButtonTapped(sender)
    }
    
    func addImageHeightConstraint(image: UIImage) {
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        // imageview width = screenwidth - 64
        let imageViewWidth = postImageView.frame.width
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let ratio = imageHeight / imageWidth
        let imageViewHeight = imageViewWidth * ratio
        imageViewHeightConstraint.constant = imageViewHeight
        postImageView.updateConstraints()
//        let imageHeightConstraint = NSLayoutConstraint(item: postImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: imageViewHeight, constant: 0)
//        self.contentView.addConstraint(imageHeightConstraint)
    }
    
}
