//
//  MapViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var user: User?
    var bars: [Bar] = []
    var selectedBar: Bar?
    var posts: [Post]?
    var annotations: [MKAnnotation] = []
    var searchController: UISearchController!
    var searchResults: [MKMapItem] = []
    var searchedLocation: CLLocation?
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MAP SEARCH -- CURRENTLY IN PROGRESS
    func setUpSearchController() {
        //set up searchController
        searchController = UISearchController(searchResultsController: nil)
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        //set up searchUpdater
        let searchUpdater = searchController.searchResultsUpdater
        searchUpdater?.updateSearchResultsForSearchController(searchController)
        //define appearance for the searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.placeholder = "search in another location"
        let searchBarTextField = searchController.searchBar.valueForKey("searchField") as? UITextField
        searchBarTextField?.textColor = UIColor.whiteColor()
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
    }
    
    func searchWithSearchTerm(searchTerm: String) {
        if let searchText = searchController.searchBar.text {
            let searchTerm = searchText.lowercaseString
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchTerm
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { (response, error) in
                if let response = response {
                    self.searchResults = response.mapItems
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.tableView.hidden = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.tableView.hidden = false
            let searchTerm = searchText.lowercaseString
            searchWithSearchTerm(searchTerm)
        } else if searchText == "" {
            self.tableView.hidden = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultsCell", forIndexPath: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let placemark = searchResults[indexPath.row].placemark
        let location = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        self.tableView.hidden = true
        centerMapOnLocation(location)
        loadBars(location)
        
        
    }
    
    
    
    
    // MARK: Actions
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        self.bars = []
        mapView.removeAnnotations(mapView.annotations)
        let centerLocation = CLLocation(latitude: mapView.region.center.latitude, longitude:mapView.region.center.longitude)
        loadBars(centerLocation)
    }
    
    
    @IBAction func locationButtonTapped(sender: UIBarButtonItem) {
        self.locationManager.startUpdatingLocation()
    }
    
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.hidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        setUpSearchController()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BarController.sharedController.currentBar = nil
    }
    
    
    // MARK: Map Functions
    
    func centerMapOnLocation(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        var latitudeDelta = 0.0
        var longitudeDelta = 0.0
        if let farthestBar = self.bars.last {
            if let barLocation = farthestBar.location {
                let signedLatitudeDelta = latitude - barLocation.coordinate.latitude
                let signedLongitudeDelta = longitude - barLocation.coordinate.longitude
                let trueLatitudeDelta = (abs(signedLatitudeDelta) * 2)
                let trueLongitudeDelta = (abs(signedLongitudeDelta) * 2)
                latitudeDelta = (trueLatitudeDelta * 1.5)
                longitudeDelta = (trueLongitudeDelta * 1.5)
            }
        }
        let coordinateRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addBarLocationAnnotation(bar: Bar) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let coordinate = bar.location?.coordinate {
                let annotation = MKPointAnnotation()
                annotation.title = bar.name
                annotation.subtitle = bar.address
                annotation.coordinate = coordinate
                print("calling mapView.addAnnotation")
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let coordinate = view.annotation?.coordinate
        let annotationLat = coordinate?.latitude
        let annotationLong = coordinate?.longitude
        
        for bar in self.bars {
            let barLat = bar.location?.coordinate.latitude
            let barLong = bar.location?.coordinate.longitude
            
            if (annotationLat == barLat) && (annotationLong == barLong) {
                self.selectedBar = bar
                performSegueWithIdentifier("toBarDetail", sender: self)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        self.annotations.append(annotation)
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        let rightButton = UIButton(type: UIButtonType.DetailDisclosure)
        rightButton.titleForState(UIControlState.Normal)
        
        pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
        let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        for bar in bars {
            if let barLocation = bar.location {
                if barLocation == annotationLocation {
                    if let emoji = bar.topEmojis.first {
                        let imageName = ("\(emoji)pin")
                        pinView!.image = UIImage(named: imageName)
                    } else {
                        pinView!.image = UIImage(named: "beerIcon")
                    }
                }
            }
        }
        pinView!.rightCalloutAccessoryView = rightButton
        
        // Check if annotation location matches user location - if so return nil to show user location
        if (annotation.coordinate.latitude == self.mapView.userLocation.coordinate.latitude) && (annotation.coordinate.longitude == self.mapView.userLocation.coordinate.longitude) {
            return nil
        } else {
            return pinView
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            loadBars(location)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    // MARK: Helper Functions
    
    func loadBars(location: CLLocation) {
        BarController.loadBars(location, nextPageToken: nil) { (bars, nextPageToken) ->
            Void in
            if let bars = bars {
                self.loadPosts(location, bars: bars)
            }
        }
    }

    func loadPosts(location: CLLocation, bars: [Bar]) {
        PostController.postsForLocation(location, radius: 1.0, completion: { (posts, error) -> Void in
            if let posts = posts {
                self.posts = posts
                for var bar in bars {
                    if let barLocation = bar.location {
                        bar.topEmojis = self.topEmojisForLocation(barLocation)
                        if !self.bars.contains(bar) {
                            self.bars.append(bar)
                        }
                        print(bar.topEmojis)
                        print("Calling addBarLocationAnnotation")
                        self.addBarLocationAnnotation(bar)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.bars.count > 0 {
                    self.centerMapOnLocation(location)
                }
            })
        })
    }
    


    
    
//    func setPostsForLocation(location: CLLocation) {
//        PostController.postsForLocation(location, radius: 1.0) { (posts, error) -> Void in
//            self.posts = posts
//            BarController.loadBars(location, nextPageToken: nil, completion: { (bars, nextPageToken) -> Void in
//                if let bars = bars {
//                    for bar in bars {
//                        if let barLocation = bar.location {
//                            if self.topEmojisForLocation(barLocation).count > 0 {
//                                print(self.topEmojisForLocation(barLocation))
//                                self.locationEmojiDictionary[barLocation] = self.topEmojisForLocation(barLocation)
//                                print("MADE IT: \(self.locationAnnotationDictionary[barLocation])")
//                                if let annotation = self.locationAnnotationDictionary[barLocation] {
//                                    print("\(annotation) CHANGED!!!")
//                                    self.mapView.removeAnnotation(annotation)
//                                    self.mapView.addAnnotation(annotation)
//                                }
//                            }
//                        }
//                    }
//                }
//            })
//        }
//    }

    func topEmojisForLocation(location: CLLocation) -> [String] {
        if let posts = self.posts {
            var emojis: [String] = []
            for post in posts {
                let postLocation = CLLocation(latitude: post.latitude, longitude: post.longitude)
                if postLocation == location {
                    //Add a constant of one for each like
                    let constant = post.likes
                    // Algorithm for date multiplier
                    var multiplier = 0
                    let now = Double(NSDate().timeIntervalSince1970)
                    let postDate = post.timestamp.doubleValue()
                    // 6 hours
                    if (now - postDate) < 21600 {
                        multiplier = 10
                    // 1 day
                    } else if (now - postDate) < 86400 {
                        multiplier = 7
                    // 10 days
                    } else if (now - postDate) < 864000 {
                        multiplier = 3
                    // 30 days
                    } else if (now - postDate) < 2592000 {
                        multiplier = 1
                    }
                    if multiplier > 0 {
                        var powerPoints = (multiplier + constant)
                        while powerPoints > 0 {
                            emojis.append(post.emojis)
                            powerPoints--
                        }
                    }
                }
            }
            var emojiCounts: [String: Int] = [:]
            for emoji in emojis {
                emojiCounts[emoji] = (emojiCounts[emoji] ?? 0) + 1
            }
            let sortedEmojiCounts = emojiCounts.sort({ (emojiCount1, emojiCount2) -> Bool in
                emojiCount1.1 > emojiCount2.1
            })
            var topEmojiArray: [String] = []
            for tuple in sortedEmojiCounts {
                topEmojiArray.append(tuple.0)
            }
            return topEmojiArray
        } else {
            return []
        }
    }


    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toBarDetail" {
            
            let detailScene = segue.destinationViewController as! BarFeedViewController
            detailScene.bar = self.selectedBar
            
        }
    }
    
    
}