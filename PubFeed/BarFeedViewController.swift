//
//  BarFeedViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class BarFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    
    var user: User?
    var bar: Bar?
    var posts: [Post]?
    
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
        loadPostsForBar()
        BarController.sharedController.currentBar = bar
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
        }
        return cell
    }
    
    
    // MARK: Helper Functions
    
    func loadBarDetails() {
        if let bar = self.bar {
            print(bar.name)
            self.nameLabel.text = bar.name
            if let priceLevel = bar.priceLevel {
                self.priceLabel.text = priceLevel.priceLevelStringFromInt()
            }
            if let openNow = bar.openNow {
                if openNow {
                    self.openNowLabel.text = "OPEN"
                } else {
                    self.openNowLabel.text = "CLOSED"
                }
            }
            self.addressLabel.text = bar.address
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
  
    }
    

}
