//
//  CustomCallout.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/20/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

class CustomCallout: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageName: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, imageName: UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
    
}

