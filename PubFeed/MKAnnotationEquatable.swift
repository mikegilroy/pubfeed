//
//  MKAnnotationEquatable.swift
//  PubFeed
//
//  Created by Edward Suczewski on 1/13/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

func ==(lhs: MKAnnotation, rhs: MKAnnotation) -> Bool {
    
    return (lhs.coordinate.latitude == rhs.coordinate.latitude) && (lhs.coordinate.longitude == rhs.coordinate.longitude)
}
    