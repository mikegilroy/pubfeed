//
//  SignupViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    // MARK: Properties
    
    var user: User?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView ()

    
    // MARK: Outlet
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addProfilePhotoButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var secondView: UIView!
    
    // MARK: Actions
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        self.view.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if (usernameTextField.text == "") || (emailTextField.text == "") || (passwordTextField.text == "") {
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            ErrorHandling.defaultErrorHandler(nil, title: "Missing Information")
            
        } else {
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            UserController.createUser(usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) -> Void in
                if error == nil {
                    self.view.endEditing(true)
                    self.emailTextField.resignFirstResponder()
                    self.passwordTextField.resignFirstResponder()
                    self.usernameTextField.resignFirstResponder()
                    self.addProfilePhotoButton.resignFirstResponder()
                    self.user = user
                    self.performSegueWithIdentifier("toAddPhoto", sender: nil)
                    
                } else {
                    ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
                }
            })
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        let tapRecogniser = UITapGestureRecognizer(target: self, action: "userTappedView:")
        secondView.addGestureRecognizer(tapRecogniser)
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAddPhoto" {
            if let destinationController = segue.destinationViewController as? AddProfilePhotoViewController {
                _ = destinationController.view
                destinationController.user = self.user
            }
        }
    }
    
    
    // MARK: TEXTFIELDS (DELEGATE) & Keyboard Dismissal
    func userTappedView(sender: AnyObject) -> Void {
        view.endEditing(true)
    }
    
}


extension SignupViewController: UITextFieldDelegate {
    
    // Dismiss TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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