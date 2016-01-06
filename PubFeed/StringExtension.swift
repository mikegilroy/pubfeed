//
//  StringExtension.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

extension String {
    
    func dateValue() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .LongStyle
        if let date: NSDate = dateFormatter.dateFromString(self) {
            return date
        } else {
            return nil
        }
    }
    
}
