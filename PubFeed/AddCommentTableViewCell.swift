//
//  AddCommentTableViewCell.swift
//  PubFeed
//
//  Created by Thang H Tong on 1/12/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class AddCommentTableViewCell: UITableViewCell, PostDetailViewControllerDelegate {
    
    
    var post: Post?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    // MARK: - Add Comment Function
    
    func addComment() {
        
        if self.commentTextField.text == "" {
            print("no comment")
        } else {
            
            CommentController.addCommentToPost(self.post!, text: self.commentTextField.text!, completion: { (comment, error) -> Void in
                if error == nil {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("updateComment", object: nil)
               
                    self.commentTextField.text = ""
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    func updateWithUser(post: Post, user: User) {
        self.post = post
        
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = 16
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.blackColor().CGColor
        
        ImageController.profilePhotoForIdentifier(user.identifier!) { (photoUrl) -> Void in
            if let photoUrl = photoUrl {
                ImageController.fetchImageAtUrl(photoUrl, completion: { (image) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.profileImage.image = image
                    })
                })
            }
        }
    }
    
    //MARK: - Keyboard customize
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = .Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "ADD", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items: [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.commentTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.addComment()
    }
    
}
