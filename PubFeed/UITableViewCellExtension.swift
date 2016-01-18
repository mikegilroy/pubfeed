//
//  UITableViewCellExtension.swift
//  PubFeed
//
//  Created by Edward Suczewski on 1/17/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

extension UITableViewCell {
    
    func addCustomSeperator(lineColor: UIColor) {
        let seperatorView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
        seperatorView.backgroundColor = lineColor
        self.addSubview(seperatorView)
    }
    
}
