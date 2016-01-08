//
//  NetworkController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 07/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkController {
    
    static let sharedInstance = NetworkController()

    private let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    private let endURL = "&types=bar&key=AIzaSyC7yWoWuq6_U8U-kanl9g6Rk4r1ziUU-0E"
    
    static func searchURL(location: CLLocation, radius: Int, nextPageToken: String?) -> NSURL {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let locationString  = "\(latitude),\(longitude)"
        let radiusString = "&radius=\(radius)"
        
        var stringURL = NetworkController.sharedInstance.baseURL + locationString + radiusString + NetworkController.sharedInstance.endURL
        if let nextPageToken = nextPageToken {
            stringURL += "&pagetoken=\(nextPageToken)"
        }
        return NSURL(string: stringURL)!
    }
    
    static func dataAtURL(url: NSURL, completion: (data: NSData?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url) { (data, _, error) -> Void in
            
            if let _ = error {
                completion(data: nil)
                print("error getting dataTask")
                return
            }
            
            if let data = data {
                
                completion(data: data)
                
            } else {
                completion(data: nil)
                print("error getting data")
                return
            }
        }
        dataTask.resume()
    }
    
}