//
//  MapViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: Properties
    
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var user: User?
    
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: Actions
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }
    
    
    // MARK: Map Functions
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(coordinateRegion, animated: true)
        BarController.loadBars(location, nextPageToken: nil) { (bars, nextPageToken) -> Void in
            print(nextPageToken)
            var barsArray: [Bar] = []
            if let bars = bars {
                for bar in bars {
                    barsArray.append(bar)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.addBarLocationAnnotation(bar)
                    })
                }
                if let secondPageToken = nextPageToken {
                    BarController.loadBars(location, nextPageToken: secondPageToken, completion: { (bars, nextPageToken) -> Void in
                        print(nextPageToken)
                        if let bars = bars {
                            for bar in bars {
                                barsArray.append(bar)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.addBarLocationAnnotation(bar)
                                })
                            }
                        }
                        if let thirdPageToken = nextPageToken {
                            BarController.loadBars(location, nextPageToken: thirdPageToken, completion: { (bars, nextPageToken) -> Void in
                                print(nextPageToken)
                                if let bars = bars {
                                    for bar in bars {
                                        barsArray.append(bar)
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
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = bar.name
            mapView.addAnnotation(annotation)
        }
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
    
    }
    

}
