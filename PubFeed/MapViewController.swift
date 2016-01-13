//
//  MapViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: Properties
    
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var user: User?
    var bars: [Bar] = []
    var selectedBar: Bar?
    var posts: [Post]?
    var annotations: [MKAnnotation] = []
    
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    

    // MARK: Actions
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        self.bars = []
        mapView.removeAnnotations(mapView.annotations)
        let centerLocation = CLLocation(latitude: mapView.region.center.latitude, longitude:mapView.region.center.longitude)
        loadBars(centerLocation)
        self.setPostsForLocation(centerLocation)
        if self.bars.count > 0 {
            centerMapOnLocation(centerLocation)
        }
    }
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    // MARK: Map Functions
    
    func centerMapOnLocation(location: CLLocation) {
        
        var latitudeDelta = 0.02
        var longitudeDelta = 0.02
        if let furthestBarLocation = self.bars.last?.location {
            latitudeDelta = furthestBarLocation.coordinate.latitude - location.coordinate.latitude
            longitudeDelta = furthestBarLocation.coordinate.longitude - location.coordinate.longitude
        }
        
        var largestDelta = 0.02
        if latitudeDelta > longitudeDelta {
            largestDelta = latitudeDelta * 3
        } else {
            largestDelta = longitudeDelta * 3
        }
        if largestDelta < 0 {
            largestDelta = largestDelta * -1
        }
        
        let coordinateRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: largestDelta, longitudeDelta: largestDelta))
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addBarLocationAnnotation(bar: Bar) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let coordinate = bar.location?.coordinate {
                let annotation = MKPointAnnotation()
                annotation.title = bar.name
                annotation.subtitle = bar.address
                annotation.coordinate = coordinate
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
        
        if pinView == nil {
            
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.image = UIImage(named: "dancing")
            pinView!.rightCalloutAccessoryView = rightButton
            let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let emojisForLocation = self.topEmojisForLocation(location)
            print(emojisForLocation)

        } else {
            pinView!.annotation = annotation
        }
        
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
            self.setPostsForLocation(location)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    // MARK: Helper Functions
    
    func loadBars(location: CLLocation) {
        BarController.loadBars(location, nextPageToken: nil) { (bars, nextPageToken) -> Void in
            if let bars = bars {
                for bar in bars {
                    if !self.bars.contains(bar) {
                        self.bars.append(bar)
                        self.addBarLocationAnnotation(bar)
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self.bars.count > 0 {
                        self.centerMapOnLocation(location)
                    }
                })
            }
        }
    }
    
    func setPostsForLocation(location: CLLocation) {
        PostController.postsForLocation(location, radius: 1.0) { (posts, error) -> Void in
            self.posts = posts
        }
    }
    
    // The top emoji is first in the array.
    func topEmojisForLocation(location: CLLocation) -> [String] {
        if let posts = self.posts {
            var emojis: [String] = []
            for post in posts {
                let postLocation = CLLocation(latitude: post.latitude, longitude: post.longitude)
                if postLocation == location {
                    emojis.append(post.emojis)
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
