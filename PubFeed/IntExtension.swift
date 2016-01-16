//
//  IntExtension.swift
//  PubFeed
//
//  Created by Mike Gilroy on 08/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

extension Int {
    
    func priceLevelStringFromInt() -> String {
        switch self {
        case 0, 1:
            return "💰"
        case 2:
            return "💰💰"
        case 3:
            return "💰💰💰"
        case 4:
            return "💰💰💰💰"
        default:
            return ""
        }
    }
}