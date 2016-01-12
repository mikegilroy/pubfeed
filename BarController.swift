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
    
    static let sharedController = BarController()
    
    var currentBar: Bar?
    var loadedBars: [Bar] = []
    
    static func loadBars(location: CLLocation, nextPageToken: String?, completion: (bars: [Bar]?, nextPageToken: String?) -> Void) {
        
        var placesURL = NSURL()
        if let nextPageToken = nextPageToken {
            placesURL = NetworkController.searchURL(location, radius: 1000, nextPageToken: nextPageToken)
        } else {
            placesURL = NetworkController.searchURL(location, radius: 1000, nextPageToken: nil)
        }
        
        NetworkController.dataAtURL(placesURL) { (data) -> Void in
            
            guard let data = data else { completion(bars: nil, nextPageToken: nil); return }
            
            do {
                if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] {
                    
                    if let placesResultsArray = jsonData["results"] as? [[String: AnyObject]] {
                        
                        var bars: [Bar] = []
                        for place in placesResultsArray {
                            
                            if let bar = Bar(jsonDictionary: place) {
                                bars.append(bar)
                                print(bar.name)
                            }
                        }
                        if let nextPageToken = jsonData["next_page_token"] as? String {
                            completion(bars: bars, nextPageToken: nextPageToken)
                        } else {
                            completion(bars: bars, nextPageToken: nil)
                        }
                        
                    } else {
                        completion(bars: nil, nextPageToken: nil)
                        print("No bar results")
                    }
                } else {
                    completion(bars: nil, nextPageToken: nil)
                    print("Error serialising json data")
                }
            } catch {
                completion(bars: nil, nextPageToken: nil)
                print("Error getting json data")
            }
        }
    }
    
    
    
    static func loadBarsAllPages(location: CLLocation, nextPageToken: String?, completion: (bars: [Bar]?, nextPageToken: String?) -> Void) {

        if let nextPageToken = nextPageToken {
            BarController.loadBars(location, nextPageToken: nextPageToken, completion: { (bars, nextPageToken) -> Void in
                if let bars = bars {
                    for bar in bars {
                        BarController.sharedController.loadedBars.append(bar)
                    }
                }
                if let nextPageToken = nextPageToken {
                    loadBarsAllPages(location, nextPageToken: nextPageToken, completion: { (bars, nextPageToken) -> Void in
                        
                    })
                } else {
                    completion(bars: BarController.sharedController.loadedBars, nextPageToken: nil)
                }
            })
            
        } else {
            BarController.sharedController.loadedBars = []
            BarController.loadBars(location, nextPageToken: nil, completion: { (bars, nextPageToken) -> Void in
                if let bars = bars {
                    for bar in bars {
                        BarController.sharedController.loadedBars.append(bar)
                    }
                }
                if let nextPageToken = nextPageToken {
                    print(nextPageToken)
                    loadBarsAllPages(location, nextPageToken: nextPageToken, completion: { (bars, nextPageToken) -> Void in
                        
                    })
                } else {
                    completion(bars: BarController.sharedController.loadedBars, nextPageToken: nil)
                }
            })
        }
    }
    
}