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
    var searchedBarCities: [String] = []
    var bars: [Bar] = []
    var recentBarsExist: Bool {
        return BarController.sharedController.recentBars.count > 0
    }
    var searchedBarsExist: Bool {
        return searchedBars.count > 0
    }
    
    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    
    // MARK: Actions
    
    @IBAction func clearButtonTapped(sender: UIBarButtonItem) {
        self.searchedBars.removeAll()
        self.searchedBarCities.removeAll()
        tableView.reloadData()
        clearButton.enabled = false
    }
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        clearButton.enabled = false
    }
    
    // MARK: TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchedBarsExist {
            return 1
        } else if recentBarsExist {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedBarsExist {
            return searchedBars.count
        } else if recentBarsExist {
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
        if searchedBarsExist {
            cell.textLabel?.text = searchedBars[indexPath.row].name
            cell.detailTextLabel?.text = searchedBarCities[indexPath.row]
        } else if recentBarsExist {
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
                    for bar in self.searchedBars {
                        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: bar.location!.coordinate.latitude, longitude: bar.location!.coordinate.longitude), completionHandler: { (placemarks, error) -> Void in
                            if let placemarks = placemarks {
                                
                                if let city = placemarks[0].addressDictionary!["City"] as? NSString {
                                    self.searchedBarCities.append(String(city))
                                    if self.searchedBars.count == self.searchedBarCities.count {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.clearButton.enabled = true
                                            self.tableView.reloadData()
                                        })
                                    }
                                }
                            }
                        })
                    }
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
