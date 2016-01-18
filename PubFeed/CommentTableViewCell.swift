//
//  CommentTableViewCell.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit


class CommentTableViewCell: UITableViewCell {
    
    var user: User?
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithComment(comment: Comment) {
        self.addCustomSeperator(UIColor.lightGrayColor())
        
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.cornerRadius = 15
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.borderColor = UIColor.blackColor().CGColor
        
        ImageController.profilePhotoForIdentifier(comment.userIdentifier) { (photoUrl) -> Void in
            if let photoUrl = photoUrl {
                ImageController.fetchImageAtUrl(photoUrl, completion: { (image) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let image = image  {
                            self.profilePhoto.image = image
                        } else {
                            self.profilePhoto.image = UIImage(named: "defaultProfilePhoto")
                        }
                    })
                })
            } else {
                self.profilePhoto.image = UIImage(named: "defaultProfilePhoto")
            }
        }
        self.usernameLabel.text = comment.username
        self.commentLabel.text = comment.text
        self.timestampLabel.text = "\(comment.timestamp.offsetFrom(NSDate()))"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
