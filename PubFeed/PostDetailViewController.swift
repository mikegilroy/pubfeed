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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    
    
    // MARK: Actions
    
    func updateWithPost(post: Post) {
        
        self.post = post
        
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
                        self.profilePhoto.image = image
                    })
                })
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
        
        self.postText.text = post.text
    }
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCommentTableView", name: "updateComment", object: nil)
        
//        if let post = self.post {
//            self.updateWithPost(post)
//        }
    }
    
    func reloadCommentTableView () {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            if let post = self.post {
                self.updateWithPost(post)
            }
            self.tableView.reloadData()
        })
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
}

protocol PostDetailViewControllerDelegate {
    func addComment()
    func addDoneButtonOnKeyboard()
}

extension PostDetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
