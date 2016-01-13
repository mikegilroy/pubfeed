//
//  LocationExtension.swift
//  PubFeed
//
//  Created by Edward Suczewski on 1/12/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

func ==(lhs: CLLocation, rhs: CLLocation) -> Bool {
    
    return (lhs.coordinate.latitude == rhs.coordinate.latitude) && (rhs.coordinate.longitude == rhs.coordinate.longitude)
}
    