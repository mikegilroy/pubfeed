//
//  CustomPin.swift
//  PubFeed
//
//  Created by Mike Gilroy on 07/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class CustomPin: NSObject, MKAnnotation {

        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        let image = UIImage(named: "beerclink")
        init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }
    
}
