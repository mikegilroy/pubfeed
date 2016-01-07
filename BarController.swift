//
//  BarController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 07/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import CoreLocation

class BarController {
    
    static func loadBars(location: CLLocation, completion: (bars: [Bar]?) -> Void) {
        
        let placesURL = NetworkController.searchURL(location, radius: 1000)
        
        NetworkController.dataAtURL(placesURL) { (data) -> Void in
            
            guard let data = data else { completion(bars: nil); return }
            
            do {
                if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] {
                    
                    if let placesResultsArray = jsonData["results"] as? [[String: AnyObject]] {
                        
                        var bars: [Bar] = []
                        for place in placesResultsArray {
                            
                            if let bar = Bar(jsonDictionary: place) {
                                bars.append(bar)
                            }
                        }
                        completion(bars: bars)
                        
                    } else {
                        completion(bars: nil)
                        print("No bar results")
                    }
                } else {
                    completion(bars: nil)
                    print("Error serialising json data")
                }
            } catch {
                completion(bars: nil)
                print("Error getting json data")
            }
        }
    }
    
}