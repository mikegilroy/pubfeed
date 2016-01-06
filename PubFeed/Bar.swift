//
//  Bar.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

struct Bar {
    
    // MARK: Properties
    var name: String
    var address: String
//    var location: CLLocation
    var phoneNumber: String?
    var url: NSURL?
    var barID: String
    
    // MARK: Initializer
    init(name: String, address: String, location: String, phoneNumber: String?, url: NSURL?, barID: String) {
        //check location parameter and change to cllocation
        self.name = name
        self.address = address
//        self.location = location
        self.phoneNumber = phoneNumber
        self.url = url
        self.barID = barID
    }
}

