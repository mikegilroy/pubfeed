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
        self.locationManager.requestLocation()
    }
    
    
    // MARK: Map Functions
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(coordinateRegion, animated: true)
        BarController.loadBars(location, nextPageToken: nil) { (bars, nextPageToken) -> Void in
            if let bars = bars {
                for bar in bars {
                    self.bars.append(bar)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.addBarLocationAnnotation(bar)
                    })
                }
                if nextPageToken != nil {
                    BarController.loadBars(location, nextPageToken: nextPageToken, completion: { (bars, nextPageToken) -> Void in
                            if let bars = bars {
                                for bar in bars {
                                    self.bars.append(bar)
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.addBarLocationAnnotation(bar)
                                    })
                                }
                            }
                        if nextPageToken != nil {
                            BarController.loadBars(location, nextPageToken: nextPageToken, completion: { (bars, nextPageToken) -> Void in
                                if let bars = bars {
                                    for bar in bars {
                                        self.bars.append(bar)
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.addBarLocationAnnotation(bar)
                                        })
                                    }
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    func addBarLocationAnnotation(bar: Bar) {
        if let coordinate = bar.location?.coordinate {
            let annotation = CustomPin(coordinate: coordinate, title: bar.name, subtitle: "")
            mapView.addAnnotation(annotation)
        }
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
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.draggable = false
                
            let rightButton = UIButton(type: UIButtonType.DetailDisclosure)
            rightButton.titleForState(UIControlState.Normal)
            //rightButton.addTarget(self, action: "calloutAccessoryTapped", forControlEvents: .TouchUpInside)
            pinView!.rightCalloutAccessoryView = rightButton
            
            return pinView
    }
    
    func calloutAccessoryTapped() {
        performSegueWithIdentifier("toBarDetail", sender: self)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            print(location)
            centerMapOnLocation(location)
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
