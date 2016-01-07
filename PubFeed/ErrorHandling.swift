//
//  ErrorHandling.swift
//  PubFeed
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import UIKit

struct ErrorHandling {
    
   
    static let ErrorOKButton  = "Ok"
    static let ErrorDefaultMessage  = "Please try again"
    

    static func defaultErrorHandler(error: NSError?, title: String) {
        let alert = UIAlertController(title: title, message: ErrorDefaultMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButton, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0] 
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)

    }

}