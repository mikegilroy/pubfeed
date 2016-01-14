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

    // MARK: Outlets
    
    @IBOutlet weak var barLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var emoji1: UIButton!
    
    @IBOutlet weak var emoji2: UIButton!
    
    @IBOutlet weak var emoji3: UIButton!
    
    @IBOutlet weak var emoji4: UIButton!
    
    @IBOutlet weak var emoji5: UIButton!
    
    @IBOutlet weak var emoji6: UIButton!
    
    @IBOutlet weak var emoji7: UIButton!
    
    @IBOutlet weak var emoji8: UIButton!
    
    @IBOutlet weak var emoji9: UIButton!
    
    @IBOutlet weak var emoji10: UIButton!
    
    @IBOutlet weak var emoji11: UIButton!
    
    @IBOutlet weak var emoji12: UIButton!
    
    @IBOutlet weak var emoji13: UIButton!
    
    @IBOutlet weak var emoji14: UIButton!
    
    @IBOutlet weak var emoji15: UIButton!
    
    @IBOutlet weak var emoji16: UIButton!
    
    
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
//                            let segue = 
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
    
    
    @IBAction func emoji1(sender: UIButton) {
        let alpha = CGFloat(0.5)
        resetSelectedEmojiToDefaultAlpha(alpha)
        switch sender.tag {
        case 1:
            emoji1.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[0]
        case 2:
            emoji2.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[1]
        case 3:
            emoji3.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[2]
        case 4:
            emoji4.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[3]
        case 5:
            emoji5.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[4]
        case 6:
            emoji6.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[5]
        case 7:
            emoji7.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[6]
        case 8:
            emoji8.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[7]
        case 9:
            emoji9.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[8]
        case 10:
            emoji10.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[9]
        case 11:
            emoji11.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[10]
        case 12:
            emoji12.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[11]
        case 13:
            emoji13.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[12]
        case 14:
            emoji14.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[13]
        case 15:
            emoji15.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[14]
        case 16:
            emoji16.alpha = CGFloat(1.0)
            selectedEmoji = emojiMenu[15]
        default:
            print("emoji changing error")
        }
    }
    
    
    
        // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = selectedBar?.name {
            self.barLabel.text = name
        }
        emoji1.setBackgroundImage(UIImage(named: emojiMenu[2]), forState: .Normal)
        
    }
    
    // MARK: Functions
    func resetSelectedEmojiToDefaultAlpha(alpha: CGFloat) {
        if let selectedEmoji = self.selectedEmoji {
            if let index = emojiMenu.indexOf(selectedEmoji) {
                switch Int(index) {
                case 0:
                    emoji1.alpha = alpha
                case 1:
                    emoji2.alpha = alpha
                case 2:
                    emoji3.alpha = alpha
                case 3:
                    emoji4.alpha = alpha
                case 4:
                    emoji5.alpha = alpha
                case 5:
                    emoji6.alpha = alpha
                case 6:
                    emoji7.alpha = alpha
                case 7:
                    emoji8.alpha = alpha
                case 8:
                    emoji9.alpha = alpha
                case 9:
                    emoji10.alpha = alpha
                case 10:
                    emoji11.alpha = alpha
                case 11:
                    emoji12.alpha = alpha
                case 12:
                    emoji13.alpha = alpha
                case 13:
                    emoji14.alpha = alpha
                case 14:
                    emoji15.alpha = alpha
                case 15:
                    emoji16.alpha = alpha
                default:
                    print("emoji selection error")
                }
            }
        }
    }
    
}


