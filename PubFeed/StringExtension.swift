//
//  StringExtension.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

extension String {
    
//    func dateValue() -> NSDate? {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = .LongStyle
//        dateFormatter.timeStyle = .LongStyle
//        let date = dateFormatter.dateFromString(self)
//        return date
//    }

    func dateValue() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
        return dateFormatter.dateFromString(self)
    }
    
}
