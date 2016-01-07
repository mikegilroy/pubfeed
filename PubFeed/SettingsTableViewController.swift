//
//  SettingsTableViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: Properties
    
    
    // MARK: Outlets
    
    
    // MARK: Actions
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        UserController.logoutUser()
        self.tabBarController?.performSegueWithIdentifier("noCurrentUser", sender: nil)
    }
    
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
