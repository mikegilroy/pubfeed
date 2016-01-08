//
//  NewPostTableTableViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class NewPostTableTableViewController: UITableViewController {

    // MARK: Properties
    var selectedBar: Bar?
    
    // MARK: Outlets
    
    @IBOutlet weak var barNameLabel: UILabel!
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
    @IBOutlet weak var textView: UITextView!
    
    // MARK: Actions
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        if emoji1.selected == false {
            print("YES!")
        }
    }

    
}
