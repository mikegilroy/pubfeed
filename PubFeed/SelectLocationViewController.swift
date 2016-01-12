//
//  SelectLocationViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit
import Firebase

class SelectLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    // MARK: Properties
    
    var locationManager = CLLocationManager()
    var bars: [Bar] = []
    
    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if BarController.sharedController.currentBar != nil {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if BarController.sharedController.currentBar != nil {
            if section == 0 {
                return 1
            } else {
                return bars.count
            }
        } else {
            return bars.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("placeCell", forIndexPath: indexPath)
        if let currentBar = BarController.sharedController.currentBar {
            if indexPath.section == 0 {
                cell.textLabel?.text = currentBar.name
            } else {
                cell.textLabel?.text = bars[indexPath.row].name
            }
        } else {
            cell.textLabel?.text = bars[indexPath.row].name
        }
        return cell
    }
    
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toNewPost", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            BarController.loadBars(location, nextPageToken: nil, completion: { (bars, nextPageToken) -> Void in
                if let bars = bars {
                    self.bars = bars
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                        self.locationManager.stopUpdatingLocation()
                    })
                }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        print(error.localizedDescription)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toNewPost" {
            if let newPostTableTableViewController = segue.destinationViewController as? NewPostTableTableViewController {
                    if let cell = sender as? UITableViewCell,
                        let indexPath = tableView.indexPathForCell(cell) {
                            newPostTableTableViewController.selectedBar = self.bars[indexPath.row]
                }
            }
            
        }
    }
    

}
