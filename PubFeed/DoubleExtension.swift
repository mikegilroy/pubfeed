//
//  DoubleExtension.swift
//  PubFeed
//
//  Created by Edward Suczewski on 1/14/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

extension Double {
    
    func dateValue() -> NSDate {
        return NSDate(timeIntervalSince1970: self)
    }
    
}