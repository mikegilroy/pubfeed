//
//  CustomPin.swift
//  PubFeed
//
//  Created by Mike Gilroy on 07/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

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
