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
            
            let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editButtonTapped:")
            self.navigationController?.navigationItem.leftBarButtonItem = editButton
            self.navigationItem.setLeftBarButtonItem(editButton, animated: true)
            
        case .editView:
            
            if let user = UserController.sharedController.currentUser {
                usernameTextField.text = user.username
                emailTextField.text = user.email
            }
            
            saveButton.enabled = true
            
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "editButtonTapped:")
            self.navigationController?.navigationItem.leftBarButtonItem = cancelButton
            self.navigationItem.setLeftBarButtonItem(cancelButton, animated: true)
        }
    }
    
    
    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        
        if let buttonTitle = sender.title {
            switch buttonTitle {
            case "Edit":
                self.mode = .editView
                updateViewForMode(mode)
            case "Cancel":
                self.mode = .defaultView
                updateViewForMode(mode)
            default:
                updateViewForMode(mode)
            }
        }
    }
    
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        
        if (usernameTextField.text == "") || (emailTextField.text == "") {
            ErrorHandling.defaultErrorHandler(nil, title: "Missing Information")
            updateViewForMode(ViewMode.defaultView)
            
        } else {
            UserController.updateUser(UserController.sharedController.currentUser!, username: usernameTextField.text!, email: emailTextField.text!, completion: { (user, error) -> Void in
                
                if let user = UserController.sharedController.currentUser {
                    
                    self.presentValidationAlertWithTitle("Success!", text: "Thank you, \(user.username), your account at \(user.email) has been updated.")
                    
                    if error == nil {
                        self.updateViewForMode(ViewMode.defaultView)
                    }
                    
                } else {
                    ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
                }
            })
        }
    }
    
    
    @IBAction func deleteAccountTapped(sender: AnyObject) {
        var inputTextField: UITextField?
        let alertController = UIAlertController(title: "Are you sure you want to delete your account?", message: "Please enter password.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.performSegueWithIdentifier("fromSettings", sender: nil)
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let userPasswordInput = inputTextField!.text {
                
                UserController.deleteUser(UserController.sharedController.currentUser!, password: userPasswordInput) { (errors) -> Void in
                    if let error = errors?.last {
                        ErrorHandling.defaultErrorHandler(error, title: "\(error.localizedDescription)")
                    } else {
                        let successAlertController = UIAlertController(title: "Success!", message: "Your account has been deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        successAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            UserController.sharedController.currentUser = nil
                            self.performSegueWithIdentifier("fromSettings", sender: nil)
                        }))
                        
                        self.presentViewController(successAlertController, animated: true, completion: nil)
                    }
                }
            }
        }))
        alertController.addTextFieldWithConfigurationHandler( { (userInputTextField: UITextField!) -> Void in
            userInputTextField.placeholder = "Enter Password"
            userInputTextField.keyboardType = UIKeyboardType.Default
            userInputTextField.secureTextEntry = true
            inputTextField = userInputTextField
            })
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func updatePasswordTapped(sender: AnyObject) {
        var inputOldPassTextField: UITextField?
        var inputNewPassTextField: UITextField?
        
        let alertController = UIAlertController(title: "Are you sure you want to change your password?", message: "Please enter your old and new passwords.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.performSegueWithIdentifier("fromSettings", sender: nil)
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let oldPasswordInput = inputOldPassTextField?.text {
                 if let newPasswordInput = inputNewPassTextField?.text {
                    
                    UserController.changePasswordForUser(UserController.sharedController.currentUser!, oldPassword: oldPasswordInput, newPassword: newPasswordInput) { (error) -> Void in
                        if let error = error {
                            ErrorHandling.defaultErrorHandler(error, title: "\(error.localizedDescription)")
                        } else {
                            let successAlertController = UIAlertController(title: "Success!", message: "Your password has been changed.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            successAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                self.dismissViewControllerAnimated(true, completion: { () })
                            }))
                            
                            self.presentViewController(successAlertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }))
        
        alertController.addTextFieldWithConfigurationHandler { (userInputOldPass: UITextField!) -> Void in
            userInputOldPass.placeholder = "Enter Old Password"
            userInputOldPass.keyboardType = UIKeyboardType.Default
            userInputOldPass.secureTextEntry = true
            inputOldPassTextField = userInputOldPass
        }
        alertController.addTextFieldWithConfigurationHandler { (userInputNewPass: UITextField!) -> Void in
            userInputNewPass.placeholder = "Enter New Password"
            userInputNewPass.keyboardType = UIKeyboardType.Default
            userInputNewPass.secureTextEntry = true
            inputNewPassTextField = userInputNewPass
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
        FirebaseController.base.unauth()
    }
    
    
    @IBAction func updatePhotoTapped(sender: AnyObject) {
        
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromSettings" {
            if let destinationController = segue.destinationViewController as? LoginViewController {
                _ = destinationController.view
                
            }
        }
    }
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViewForMode(ViewMode.defaultView)
    }
    
}
