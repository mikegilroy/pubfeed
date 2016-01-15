//
//  SelectLocationViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit
import Firebase

class SelectLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    // MARK: Properties
    
    var locationManager = CLLocationManager()
    var searchedBars: [Bar] = []
    var bars: [Bar] = []
    var recentBarsExist: Bool {
        return BarController.sharedController.recentBars.count > 0
    }
    
    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if recentBarsExist {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recentBarsExist {
            if section == 0 {
                return BarController.sharedController.recentBars.count
            } else {
                return bars.count
            }
        } else {
            return bars.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("placeCell", forIndexPath: indexPath)
        if recentBarsExist {
            if indexPath.section == 0 {
                cell.textLabel?.text = BarController.sharedController.recentBars[indexPath.row].name
            } else {
                cell.textLabel?.text = bars[indexPath.row].name
            }
        } else {
            cell.textLabel?.text = bars[indexPath.row].name
        }
        return cell
    }
    
    // MARK: Search Bar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let name = searchBar.text {
            BarController.searchBarsByName(name, nextPageToken: nil, completion: { (bars, nextPageToken) -> Void in
                if let bars = bars {
                    self.searchedBars = bars
                }
            })
        }
    }
    
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        bars[indexPath.row].setAsCurrent()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Recently Viewed"
        } else if section == 1 {
            return "Bars Near You"
        } else {
            return ""
        }
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
