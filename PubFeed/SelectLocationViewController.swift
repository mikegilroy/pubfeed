//
//  SelectLocationViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class SelectLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    
    
    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("placeCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Green Pig Pub"
        return cell
    }
    
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toNewPost", sender: self)
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    

}
