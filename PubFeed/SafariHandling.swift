//
//  SafariHandling.swift
//  PubFeed
//
//  Created by Thang H Tong on 2/11/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import UIKit
import SafariServices


class SafariHandling {
    static func presentSafariVC(url: NSURL) {
        let safariVC = SFSafariViewController(URL: url)
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(safariVC, animated: true, completion: nil)
    }
}

