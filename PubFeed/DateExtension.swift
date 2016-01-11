//
//  DateExtension.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

extension NSDate: Comparable {
    
    func stringValue() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
        return dateFormatter.stringFromDate(self)
    }
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

