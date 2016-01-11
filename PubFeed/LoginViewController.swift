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
    
    
    @IBAction func forgotPasswordTapped(sender: UIButton) {
        
        var inputTextField: UITextField?
        let alertController = UIAlertController(title: "Are you sure you want to delete your account?", message: "Please enter email and press reset.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.performSegueWithIdentifier("fromSettings", sender: nil)
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            if let userEmail = inputTextField!.text {
                
                UserController.resetPasswordForUser(userEmail, completion: { (error) -> Void in
                    if let error = error {
                        ErrorHandling.defaultErrorHandler(error, title: "\(error.localizedDescription)")
                    } else {
                        let successAlertController = UIAlertController(title: "Thank you!", message: "Check your email for a link to reset your password.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        successAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        }))
                        self.presentViewController(successAlertController, animated: true, completion: nil)
                    }
                })
            }
        }))
        
        alertController.addTextFieldWithConfigurationHandler( { (userInputTextField: UITextField!) -> Void in
            userInputTextField.placeholder = "Enter Email"
            userInputTextField.keyboardType = UIKeyboardType.Default
            userInputTextField.secureTextEntry = true
            inputTextField = userInputTextField
        })
        presentViewController(alertController, animated: true, completion: nil)
        
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
    
    
    // MARK: TEXTFIELDS (DELEGATE) & Keyboard Dismissal
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    // Dismiss TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
