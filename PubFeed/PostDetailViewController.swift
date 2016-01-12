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
    var user: User?
    var comment: Comment?
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    
    
    // MARK: Actions
    
    
    
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: TableView Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
//        ImageController.profilePhotoForIdentifier((UserController.sharedController.currentUser?.photo)!, user: UserController.sharedController.currentUser!) { (photoUrl) -> Void in
////            dispatch_async(dispatch_get_main_queue(), { () -> Void in
////                 cell.imageView?.image = photoUrl
//////            })
////            tableView.reloadData()
//            
//        }
  
        return cell
    }

  

}
