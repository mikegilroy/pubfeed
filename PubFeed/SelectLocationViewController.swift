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
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bars.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("placeCell", forIndexPath: indexPath)
        cell.textLabel?.text = bars[indexPath.row].name
        return cell
    }
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        bars[indexPath.row].setAsCurrent()
        self.performSegueWithIdentifier("unwindToNewPost", sender: nil)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bars Near You"
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            BarController.loadBars(location, nextPageToken: nil, completion: { (bars, nextPageToken) -> Void in
                if let bars = bars {
                    let sortedBars = bars.sort({ (bar1, bar2) -> Bool in
                        bar1.location?.distanceFromLocation(location) < bar2.location?.distanceFromLocation(location)
                    })
                    self.bars = sortedBars
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
    
    


}
