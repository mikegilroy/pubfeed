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
    var selectedBar: Bar?
    var selectedEmoji: String?
    var selectedPhoto: String?
    var selectedButton: UIButton?

    // MARK: Outlets

    
    @IBOutlet weak var barLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!

    @IBOutlet var emojiButton: [UIButton]!
    
    @IBOutlet weak var emojiStackCell: UITableViewCell!
    
    
    // MARK: Actions
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        guard let emojis = self.selectedEmoji else {
            print("NO EMOJI SELECTED")
            return
        }
        if let user = UserController.sharedController.currentUser {
            if let bar = selectedBar {
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
        if let name = selectedBar?.name {
            self.barLabel.text = name
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
//            emojiStackCell.sizeThatFits(CGSize(width: emojiStackCell.frame.width, height: (height*3) + 15))
            return CGFloat((height * 3) + 15)
        } else if indexPath.row == 0 {
            return 51
        } else if indexPath.row == 2 {
            return 97
        } else {
            return 0
        }
    }

    
//    // MARK: Functions
//    func resetSelectedEmojiToDefaultAlpha(alpha: CGFloat) {
//        if let selectedEmoji = self.selectedEmoji {
//            if let index = emojiMenu.indexOf(selectedEmoji) {
//                switch Int(index) {
//                case 0:
//                    emoji1.alpha = alpha
//                case 1:
//                    emoji2.alpha = alpha
//                case 2:
//                    emoji3.alpha = alpha
//                case 3:
//                    emoji4.alpha = alpha
//                case 4:
//                    emoji5.alpha = alpha
//                case 5:
//                    emoji6.alpha = alpha
//                case 6:
//                    emoji7.alpha = alpha
//                case 7:
//                    emoji8.alpha = alpha
//                case 8:
//                    emoji9.alpha = alpha
//                case 9:
//                    emoji10.alpha = alpha
//                case 10:
//                    emoji11.alpha = alpha
//                case 11:
//                    emoji12.alpha = alpha
//                case 12:
//                    emoji13.alpha = alpha
//                case 13:
//                    emoji14.alpha = alpha
//                case 14:
//                    emoji15.alpha = alpha
//                case 15:
//                    emoji16.alpha = alpha
//                default:
//                    print("emoji selection error")
//                }
//            }
//        }

}


