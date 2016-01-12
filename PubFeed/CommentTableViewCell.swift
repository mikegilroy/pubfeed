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
        
//        ImageController.profilePhotoForIdentifier((UserController.sharedController.currentUser?.photo)!, user: UserController.sharedController.currentUser!) { (photoUrl) -> Void in
//            self.profilePhoto.image = photoUrl
//        
//        }
        self.profilePhoto.image = UIImage(named: (UserController.sharedController.currentUser?.photo)!)
        self.usernameLabel.text = UserController.sharedController.currentUser?.username
        self.commentLabel.text = comment.text
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
