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
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Actions
    
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Piper is the best"
        return cell
    }
    
    
    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  
    }
    

}
