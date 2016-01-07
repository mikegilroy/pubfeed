//
//  BarController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 07/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class BarController {
    
    static let sharedInstance = BarController()
    
    
    static func loadBars(location: CLLocation, completion: (bars:[MKMapItem]?) -> Void) {
        
        var bars: [MKMapItem] = []
        
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        
//        let requestPubs = MKLocalSearchRequest()
//        requestPubs.naturalLanguageQuery = "pub"
//        
//        requestPubs.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//        
//        let search = MKLocalSearch(request: requestPubs)
//        search.startWithCompletionHandler { (response, error) in
//            guard let response = response else {
//                print("Search error: \(error)")
//                return
//            }
//            
//            for item in response.mapItems {
//                print(item)
//                bars.append(item)
//            }
//        }
        
        let requestBars = MKLocalSearchRequest()
        requestBars.naturalLanguageQuery = "bars"
        
        requestBars.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9))
        
        let searchBars = MKLocalSearch(request: requestBars)
        searchBars.startWithCompletionHandler { (response, error) in
            guard let response = response else {
                print("Search error: \(error)")
                completion(bars: nil)
                return
            }
            
            for item in response.mapItems {
                print(item)
                bars.append(item)
            }
            completion(bars: bars)
        }
    }

}