//
//  UIViewControllerExtension.swift
//  PubFeed
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

//import Foundation
//import UIKit

public extension UIViewController {
    
    // Thanks to: https://gist.github.com/MartinMoizard/6537467
    public func presentViewControllerFromTopViewController(viewControllerToPresent: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        if self is UINavigationController {
            let navigationController = self as! UINavigationController
            navigationController.topViewController!.presentViewControllerFromTopViewController(viewControllerToPresent, animated: animated, completion: nil)
        } else if (presentedViewController != nil) {
            presentedViewController!.presentViewControllerFromTopViewController(viewControllerToPresent, animated: true, completion: nil)
        } else {
            presentViewController(viewControllerToPresent, animated: animated, completion: completion)
        }
    }
    
}