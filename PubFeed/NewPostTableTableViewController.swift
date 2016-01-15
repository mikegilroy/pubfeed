//
//  NewPostTableTableViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//


import UIKit

class NewPostTableTableViewController: UITableViewController {

    let emojiMenu = ["☠", "💃", "🙈", "🍴", "😈", "🔥",
                     "🍼", "🍑", "🍆", "👴🏼", "💩", "🎸",
                    "🐌", "🌈", "⚽️", "🎉", "🎤", "🦄"]

    // MARK: Properties
    var selectedEmoji: String?
    var selectedPhoto: String?
    var selectedButton: UIButton?

    // MARK: Outlets

    
    @IBOutlet weak var barLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!

    @IBOutlet var emojiButton: [UIButton]!
    
    @IBOutlet weak var emojiStackCell: UITableViewCell!
    
    
    
    
    // MARK: Actions
    
    @IBAction func selectBarButtonTapped(sender: UIButton) {
        
    }
    
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("unwindToTabBar", sender: nil)
    }
    
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        guard let emojis = self.selectedEmoji else {
            print("NO EMOJI SELECTED")
            return
        }
        if let user = UserController.sharedController.currentUser {
            if let bar = BarController.sharedController.currentBar {
                if let location = bar.location {
                    PostController.createPost(location, emojis: emojis, text: self.textView.text, photo: selectedPhoto, bar: bar, user: user, completion: { (post, error) -> Void in
                        if let _ = error {
                            print("Error creating post")
                        } else {
                            self.performSegueWithIdentifier("unwindToTabBar", sender: nil)
                        }
                    })
                } else {
                    print("selected bar has no location")
                }
            } else {
                print("selected bar is nil")
            }
        } else {
            print("current user is nil")
        }
    }
    
    
    @IBAction func emojiTapped(sender: UIButton) {
        if selectedButton != nil {
            selectedButton!.alpha = CGFloat(0.5)
        }
        selectedEmoji = emojiMenu[sender.tag]
        selectedButton = sender
        sender.alpha = CGFloat(1.0)
    }
    
    
        // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentBar = BarController.sharedController.currentBar {
            self.barLabel.text = currentBar.name
        }
        for button in emojiButton {
            button.setBackgroundImage(UIImage(named: emojiMenu[button.tag]), forState: .Normal)
        }
        
    }
    
    // MARK: TableView Delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            let width = emojiStackCell.frame.width - 16
            let height = width/6
            return CGFloat((height * 3) + 15)
        } else if indexPath.row == 0 {
            return 51
        } else if indexPath.row == 2 {
            return 97
        } else {
            return 0
        }
    }

}


