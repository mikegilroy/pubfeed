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
    
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: Actions
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    // MARK: Map Functions
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(coordinateRegion, animated: false)
        
        let googleGroup = dispatch_group_create()
        let googleQueue1 = dispatch_queue_create("com.pubFeed.google1", nil)
        let googleQueue2 = dispatch_queue_create("com.pubFeed.google2", nil)
        let googleQueue3 = dispatch_queue_create("com.pubFeed.google3", nil)
        
        dispatch_group_enter(googleGroup)
        
        dispatch_async(googleQueue1) { () -> Void in
            
            BarController.loadBars(location, nextPageToken: nil, completion:  { (bars, nextPageToken) -> Void in
                if let bars = bars {
                    for bar in bars {
                        self.bars.append(bar)
                        print(bar.barID)
                    }
                }
                
                if let secondPageToken = nextPageToken {
                    dispatch_group_enter(googleGroup)
                    dispatch_async(googleQueue2) { () -> Void in
                        
                        BarController.loadBars(location, nextPageToken: secondPageToken, completion: { (bars, nextPageToken) -> Void in
                            if let bars = bars {
                                for bar in bars {
                                    self.bars.append(bar)
                                }
                            }
                            if let thirdPageToken = nextPageToken {
                                dispatch_group_enter(googleGroup)
                                dispatch_async(googleQueue3) { () -> Void in
                                    
                                    BarController.loadBars(location, nextPageToken: thirdPageToken, completion: { (bars, nextPageToken) -> Void in
                                        if let bars = bars {
                                            for bar in bars {
                                                self.bars.append(bar)
                                            }
                                        }
                                        dispatch_group_leave(googleGroup)
                                    })
                                }
                            } else {
                                print("No thirdPageToken")
                            }
                            dispatch_group_leave(googleGroup)
                        })
                        
                    }
                } else {
                    print("No secondPageToken")
                }
                dispatch_group_leave(googleGroup)
            })
        }
        
        dispatch_group_notify(googleGroup, dispatch_get_main_queue()) { () -> Void in
            for bar in self.bars {
                self.addBarLocationAnnotation(bar)
            }
        }
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
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        let rightButton = UIButton(type: UIButtonType.DetailDisclosure)
        rightButton.titleForState(UIControlState.Normal)
        
        if pinView == nil {
            
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.image = UIImage(named: "weener")
            pinView!.rightCalloutAccessoryView = rightButton
            
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            print(location)
            centerMapOnLocation(location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toBarDetail" {
            
            let detailScene = segue.destinationViewController as! BarFeedViewController
            detailScene.bar = self.selectedBar
        }
    }
    
    
}
