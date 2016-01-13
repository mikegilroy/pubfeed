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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithComment(comment: Comment) {
        
        if let userPhoto = comment.userPhotoUrl {
            
            ImageController.profilePhotoForIdentifier(userPhoto, user: comment.user!) { (photoUrl) -> Void in
                if let photoUrl = photoUrl {
                    ImageController.fetchImageAtUrl(photoUrl, completion: { (image) -> () in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.profilePhoto.image = image
                        })
                    })
                }
            }
        }
        self.usernameLabel.text = comment.username
        self.commentLabel.text = comment.text
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
