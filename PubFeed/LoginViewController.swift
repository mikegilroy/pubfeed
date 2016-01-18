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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView ()

    // MARK: Outlet
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var secondView: UIView!
    
    
    // MARK: Actions
    
    
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        
        //Activity Indicator View
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        self.view.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            ErrorHandling.defaultErrorHandler(nil, title: "Missing information")
        } else {
            UserController.authenticateUser(emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    let yNewCoordinate = self.view.frame.origin.y
                    let scrollNewDestination = CGPointMake(0.0, yNewCoordinate)
                    self.scrollView.setContentOffset(scrollNewDestination, animated: true)
                    
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
        let alertController = UIAlertController(title: "It looks like you forgot your account!", message: "Please enter email and press reset.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        let tapRecogniser = UITapGestureRecognizer(target: self, action: "userTappedView:")
        secondView.addGestureRecognizer(tapRecogniser)
        
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


extension LoginViewController: UITextFieldDelegate {
    
    // MARK: Dismiss TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //     MARK: TEXTFIELDS (DELEGATE) & Keyboard Dismissal
    func userTappedView(sender: AnyObject) -> Void {
        view.endEditing(true)
    }
        
    
    // MARK: Shift View on Keyboard Appearance and Removal
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            let yCoordinate = self.view.frame.origin.y + keyboardSize.height
            let scrollDestination = CGPointMake(0.0, yCoordinate)
            scrollView.setContentOffset(scrollDestination, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
            
            let yNewCoordinate = self.view.frame.origin.y
            let scrollNewDestination = CGPointMake(0.0, yNewCoordinate)
            scrollView.setContentOffset(scrollNewDestination, animated: true)
    }
    
    
}
