//
//  DateExtension.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

extension NSDate: Comparable {
//    
//    func stringValue() -> String {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm:ss zzz"
////        dateFormatter.timeStyle = .LongStyle
////        dateFormatter.dateStyle = .LongStyle
//        return dateFormatter.stringFromDate(self)
//    }
    
    func doubleValue() -> Double {
        let date = NSDate(timeIntervalSince1970: 0)
        return Double(self.secondsFrom(date))
    }
    
    func yearsFrom(date:NSDate) -> Int{
        let years = NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
        return years
    }
    
    func monthsFrom(date:NSDate) -> Int {
        let months =  NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
        return months
    }
    
    func weeksFrom(date:NSDate) -> Int {
        let weeks =  NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
        return weeks
    }
    
    func daysFrom(date:NSDate) -> Int{
        let days =  NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
        return days
    }
    
    func hoursFrom(date:NSDate) -> Int{
        let hours =  NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
        return hours
    }
    
    func minutesFrom(date:NSDate) -> Int{
        let minutes =  NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
        return minutes
    }
    
    func secondsFrom(date:NSDate) -> Int{
        let seconds =  NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
        return seconds
    }
    
    func offsetFrom(date:NSDate) -> String {
        print(yearsFrom(date))
        print(date)
        if yearsFrom(date)   <= -1 { return "\(yearsFrom(date) * -1)y"   }
        print(monthsFrom(date))
        if monthsFrom(date)  <= -1 { return "\(monthsFrom(date) * -1)M"  }
        print(weeksFrom(date))
        if weeksFrom(date)   <= -1 { return "\(weeksFrom(date) * -1)w"   }
        print(daysFrom(date))
        if daysFrom(date)    <= -1 { return "\(daysFrom(date) * -1)d"    }
        print(hoursFrom(date))
        if hoursFrom(date)   <= -1 { return "\(hoursFrom(date) * -1)h"   }
        print(minutesFrom(date))
        if minutesFrom(date) <= -1 { return "\(minutesFrom(date) * -1)m" }
        print(secondsFrom(date))
        if secondsFrom(date) <= -1 { return "\(secondsFrom(date) * -1)s" }
        return ""
    }
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

