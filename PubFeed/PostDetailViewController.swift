//
//  PostDetailViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties

    var post: Post?
    var user: User?
    var comments: [Comment] = []
    var delegate: PostDetailViewControllerDelegate?
    
    
    // MARK: Outlets
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    
    // MARK: Actions
    
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCommentTableView", name: "updateComments", object: nil)
        
        if let post = self.post {
            updateWithPost(post)
        }
        
        // Rounded profile photo
        self.profilePhoto.layer.cornerRadius = 15
        self.profilePhoto.layer.borderWidth = 1
        self.profilePhoto.layer.borderColor = UIColor.blackColor().CGColor
        self.profilePhoto.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: Helper Functions
    
    func reloadCommentTableView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            if let post = self.post {
                self.updateWithPost(post)
            }
            self.tableView.reloadData()
        })
    }
    
    func addCustomSeperator(lineColor: UIColor) {
        let seperatorView = UIView(frame: CGRect(x: 0, y: self.headerView.frame.height - 1, width: self.headerView.frame.width, height: 1))
        seperatorView.backgroundColor = lineColor
        self.headerView.addSubview(seperatorView)
    }
    
    func updateWithPost(post: Post) {
        addCustomSeperator(UIColor.lightGrayColor())
        
        self.post = post
        self.timestampLabel.text = "\(post.timestamp.offsetFrom(NSDate()))"
        self.emojiLabel.text = post.emojis
        self.postText.text = post.text
        
        UserController.userWithIdentifier(post.userIdentifier) { (user) -> Void in
            if let user = user {
                self.usernameLabel.text = user.username
            } else {
                self.usernameLabel.text = ""
                print("unknown username on post detail")
            }
        }
        
        CommentController.commentsForPost(post) { (comments) -> Void in
            self.comments = comments
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        ImageController.profilePhotoForIdentifier(post.userIdentifier) { (photoUrl) -> Void in
            if let photoUrl = photoUrl {
                ImageController.fetchImageAtUrl(photoUrl, completion: { (image) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let image = image {
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
        
        //        if let postPhoto = post.photo {
        //            ImageController.postPhotoForIdentifier(postPhoto, post: post) { (postPhotoUrl) -> Void in
        //                ImageController.fetchImageAtUrl(postPhotoUrl, completion: { (image) -> () in
        //                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //                        self.postImage.image = image
        //                    })
        //                })
        //            }
        //        } else {
        //            self.postImage.removeFromSuperview()
        //        }
        
    }

    
    // MARK: TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return self.comments.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("addComment", forIndexPath: indexPath) as! AddCommentTableViewCell
            
            if let user = UserController.sharedController.currentUser {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.updateWithUser(self.post!, user: user)
                })
            }
            self.delegate = cell
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
            
            let comment = self.comments[indexPath.row]
            cell.updateWithComment(comment)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        
        if indexPath.row != 0 {
            let comment = comments[indexPath.row]
            if comment.userIdentifier == UserController.sharedController.currentUser?.identifier! {
                return .Delete
            } else {
                return .None
            }
        } else {
            return .None
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let post = self.post else { return }
        
        let comment = self.comments[indexPath.row]
        if editingStyle == .Delete {
            CommentController.deleteComment(post, comment: comment, completion: { (error) -> Void in
                if let error = error {
                    print(error)
                } else {
                    self.comments.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 68
        default:
            return 89
        }
    }
}


// MARK: PostDetailViewControllerDelegate Protocol Declaration

protocol PostDetailViewControllerDelegate {
    func addComment()
    func addDoneButtonOnKeyboard()
}


// MARK: UITextFieldDelegate

extension PostDetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        self.delegate?.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
