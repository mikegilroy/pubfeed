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
    
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
        return cell
    }

  

}
