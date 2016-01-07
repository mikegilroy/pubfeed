//
//  LoginViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    var user: User?
    
    // MARK: Outlet
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Actions
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            ErrorHandling.defaultErrorHandler(nil, title: "Missing information")
        } else {
            UserController.authenticateUser(emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) -> Void in
                if error == nil {
                    self.user = user
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegueWithIdentifier("fromLogin", sender: nil)
                } else {
                    ErrorHandling.defaultErrorHandler(error, title:  "\(error!.localizedDescription)")
                }
            })
        }
    }
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromLogin" {
            if let destinationController = segue.destinationViewController as? MapViewController {
                _ = destinationController.view
                
                destinationController.user = self.user
            }
        }
    }
    
}
