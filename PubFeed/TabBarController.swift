//
//  TabBarController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddButton()
    }
    
    func setupAddButton() {
        let buttonView = UIView()
        let viewWidth = ((UIApplication.sharedApplication().windows.first?.frame.width)! / 3) + 10 //
        let viewHeight = (self.tabBar.frame.width / 4)
        let viewX = ((UIApplication.sharedApplication().windows.first?.frame.width)! / 2) - (viewWidth / 2)
        let viewY = (UIApplication.sharedApplication().windows.first?.frame.height)! - self.tabBar.frame.height
        
        buttonView.frame = CGRect(x:  viewX, y: viewY, width:viewWidth, height: viewHeight)
        self.view.addSubview(buttonView)
        
        let addButton = UIButton()
        let buttonWidth = CGFloat(76)//self.tabBar.frame.height * 1.5
        let buttonHeight = (self.tabBar.frame.width / 4)
        let buttonX = (viewWidth - buttonWidth) / 2
        let buttonY = CGFloat(0)
        
        addButton.frame = CGRect(x:  buttonX, y: buttonY, width:buttonWidth, height: buttonHeight)
        addButton.layer.borderColor = UIColor(red: 247/255, green: 109/255, blue: 65/255, alpha: 1.0).CGColor
        addButton.layer.borderWidth = 0
        addButton.backgroundColor = UIColor(patternImage: UIImage(named: "addButton")!)
        buttonView.addSubview(addButton)
        
        addButton.addTarget(self, action: "buttonPressed", forControlEvents: .TouchUpInside)
    }
    
    func buttonPressed() {
        performSegueWithIdentifier("addNewPost", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNewPost" {
            
        }
    }


}
