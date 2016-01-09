//
//  SettingsTableViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var profilePhoto: UIImage?
    var user: User?
    var profilePhotoIdentifier: String?
    var mode: ViewMode = .defaultView
    
    
    var fieldsAreValid: Bool {
        switch mode {
            
        case .editView:
            return !(usernameTextField.text!.isEmpty) || (emailTextField.text!.isEmpty)
            
        case.defaultView:
            return (usernameTextField.text!.isEmpty) || (emailTextField.text!.isEmpty)
        }
    }
    
    
    enum ViewMode {
        case defaultView
        case editView
    }
    
    
    // MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateProfilePhotoButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    
    // MARK: Actions
    
    func presentValidationAlertWithTitle(title: String, text: String) {
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func updateViewForMode(mode: ViewMode) {
        switch mode {
            
        case .defaultView:
            usernameTextField.text = ""
            emailTextField.text = ""
            saveButton.enabled = false
            
        case .editView:
            
            if let user = self.user {
                usernameTextField.text = user.username
                emailTextField.text = user.email
            }
            
            saveButton.enabled = true
            
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "editButtonTapped:")
            self.navigationController?.navigationItem.leftBarButtonItem = cancelButton
            self.navigationItem.setLeftBarButtonItem(cancelButton, animated: true)
        }
    }
    
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        updateViewForMode(ViewMode.editView)
    }
    
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        if !fieldsAreValid {
            ErrorHandling.defaultErrorHandler(nil, title: "Missing Information!")
            
        } else {
            UserController.updateUser(UserController.sharedController.currentUser!, username: usernameTextField.text!, email: emailTextField.text!, completion: { (user, error) -> Void in
                
                if error == nil {
                    self.user = user
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.presentValidationAlertWithTitle("Success!", text: "Thank you, \(user?.username), your account at \(user?.email) has been updated.")
                    
                } else {
                    ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
                }
            })
        }
        self.tabBarController?.performSegueWithIdentifier("noCurrentUser", sender: nil)
    }
    
    //NOT WORKING YET, GRAB PASSWORD
    @IBAction func deleteAccountTapped(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: "Are you sure you want to delete your account?", message: "Please enter your password to continue.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { ACTION in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        }
        
        alertController.addAction(actionCancel)
        //        alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
        //            textField.placeholder = "Enter Password"
        //            textField.keyboardType = UIKeyboardType.Default
        //            textField.secureTextEntry = true
        //            userPassword = textField.text!
        //        })
        
        
        let actionInput = UIAlertAction(title: "Password", style: UIAlertActionStyle.Default) { ACTION in
            
            alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
                textField.placeholder = "Enter Password"
                textField.keyboardType = UIKeyboardType.Default
                textField.secureTextEntry = true
                let userPasswordInput = textField.text!
                
                UserController.deleteUser(UserController.sharedController.currentUser!, password: userPasswordInput) { (errors) -> Void in
                    if let error = errors?.last {
                        ErrorHandling.defaultErrorHandler(error, title: "\(error.localizedDescription)")
                    }
                }
            })
        }
        
        alertController.addAction(actionInput)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func updatePasswordTapped(sender: AnyObject) {
        
    }
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
        FirebaseController.base.unauth()
    }
    
    @IBAction func updatePhotoTapped(sender: AnyObject) {
        
    }
    
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViewForMode(ViewMode.defaultView)
    }
    
}
