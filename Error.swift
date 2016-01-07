//
//  Error.swift
//  PubFeed
//
//  Created by Edward Suczewski on 1/7/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

class Error {
    
    static func defaultError() -> NSError {
        return NSError(domain: "default", code: 0, userInfo: nil)
    }
}
