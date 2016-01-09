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
    
    // MARK: Outlet
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addProfilePhotoButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        
        if (usernameTextField.text == "") || (emailTextField.text == "") || (passwordTextField.text == "") {
            ErrorHandling.defaultErrorHandler(nil, title: "Missing Information")
            
        } else {
            UserController.createUser(usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) -> Void in
                if error == nil {
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
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    
    // Dismiss TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}