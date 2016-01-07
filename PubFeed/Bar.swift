//
//  Bar.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import CoreLocation

struct Bar {
    
    // MARK: Keys
    let kID = "id"
    let kName = "name"
    let kAddress = "vicinity"
    let kPriceLevel = "price_level"
    let kRating = "rating"
    
    
    // MARK: Properties
    var name: String
    var address: String
    var location: CLLocation?
    var priceLevel: Int?
    var rating: Double?
    var openNow: Bool?
    var barID: String
    
    // MARK: Initializer
    
    init?(jsonDictionary: [String: AnyObject]) {
        
        if let name = jsonDictionary[kName] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let address = jsonDictionary[kAddress] as? String {
            self.address = address
        } else {
            self.address = ""
        }
        
        let barID = jsonDictionary[kID] as! String
        
        if let priceLevel = jsonDictionary[kPriceLevel] as? Int {
            self.priceLevel = priceLevel
        } else {
            self.priceLevel = nil
        }
        
        if let rating = jsonDictionary[kRating] as? Double {
            self.rating = rating
        } else {
            self.rating = nil
        }
        
        if let openingHours = jsonDictionary["opening_hours"] as? [String: AnyObject] {
            if let openNow = openingHours["open_now"] as? Bool {
                self.openNow = openNow
            }
        }
        
        if let geometry = jsonDictionary["geometry"] as? [String: AnyObject] {
            let locationDictionary = geometry["location"] as! [String: AnyObject]
            let latitude = locationDictionary["lat"] as! Double
            let longitude = locationDictionary["lng"] as! Double
            let location = CLLocation(latitude: latitude, longitude: longitude)
            self.location = location
        }
        
        self.barID = barID

    }
}

