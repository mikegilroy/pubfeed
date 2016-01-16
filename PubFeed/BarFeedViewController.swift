//
//  BarFeedViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class BarFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate {
    
    // MARK: Properties
    
    
    var user: User?
    var bar: Bar?
    var posts: [Post]?
    
    var selectedPost: Post?
    
    var oldIndexPath: NSIndexPath? = nil
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    // MARK: Actions
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBarDetails()
        //loadPostsForBar()
        if let bar = bar {
            bar.setAsCurrent()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        loadPostsForBar()
        
        if let indexPath = oldIndexPath as NSIndexPath! {
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    
    // MARK: TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let postsArray = posts {
            return postsArray.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
        
        if let posts = self.posts {
            let post = posts[indexPath.row]
            cell.updateCellWithPost(post)
            cell.updateUserLikesPost(post)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor().pinkTintColor()
        header.backgroundView?.alpha = 0.9
        header.textLabel!.textColor = UIColor.whiteColor()//UIColor().pinkTintColor()
        header.textLabel!.frame = header.frame
        header.textLabel!.textAlignment = NSTextAlignment.Left
        header.textLabel?.font = UIFont(name: "CaviarDreams", size: 20)
        header.textLabel!.text = "⏲ Recent Activity"
    }
    

    
    // MARK: PostTableViewCellDelegate
    var isLiked: Bool?
    
    func likeButtonTapped(sender: PostTableViewCell) {
        if let indexPath = tableView.indexPathForCell(sender) {
            if let posts = self.posts {
                let post = posts[indexPath.row]
//                    LikeController.toggleLike(<#T##like: Like##Like#>, post: post, isLiked: self.isLiked, completion: { (isLiked, error) -> Void in
//                        <#code#>
//                    })
            }
        }
    }
    
    // MARK: Helper Functions
    
    func loadBarDetails() {
        if let bar = self.bar {
            print(bar.name)
            self.nameLabel.text = bar.name
            if let priceLevel = bar.priceLevel {
                self.priceLabel.text = priceLevel.priceLevelStringFromInt()
                print(priceLevel)
                print(priceLevel.priceLevelStringFromInt())
            } else {
                self.priceLabel.text = ""
            }
            if let openNow = bar.openNow {
                if openNow {
                    self.openNowLabel.text = "OPEN"
                    self.openNowLabel.textColor = UIColor.greenColor()
                } else {
                    self.openNowLabel.text = "CLOSED"
                    self.openNowLabel.textColor = UIColor.redColor()
                }
            }
            self.addressLabel.text = bar.address
            let topEmojis = bar.topEmojis
            if topEmojis.count > 0 {
                if topEmojis.count == 1 {
                    self.emojiLabel.text = "\(topEmojis[0])"
                } else if topEmojis.count == 2 {
                    self.emojiLabel.text = "\(topEmojis[0]) \(topEmojis[1])"
                } else {
                    self.emojiLabel.text = "\(topEmojis[0]) \(topEmojis[1]) \(topEmojis[2])"
                }
            } else {
                self.emojiLabel.text = "❓❓❓"
            }
        }
    }
    
    func loadPostsForBar() {
        if let bar = self.bar {
            print(bar.barID)
            PostController.postsForBar(bar) { (posts) -> Void in
                self.posts = posts
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDetailView" {
            if let postDetailDestination = segue.destinationViewController as? PostDetailViewController {
                _ = postDetailDestination.view
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    self.oldIndexPath = indexPath
                    if let post = self.posts?[indexPath.row] {
                        self.selectedPost = post
                        postDetailDestination.updateWithPost(post)
                    }
                }
            }
        }
    }
}
