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
    func updateViewForMode(mode: ViewMode) {
        switch mode {
            
        case .defaultView:
            usernameTextField.text = ""
            emailTextField.text = ""
            saveButton.enabled = false
            
        case .editView:
            saveButton.enabled = true
            if let user = self.user {
                usernameTextField.text = user.username
                emailTextField.text = user.email
            }
        }
    }
    
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        updateViewForMode(ViewMode.editView)
    
    }
    
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        if !fieldsAreValid {
            ErrorHandling.defaultErrorHandler(nil, title: "Missing Information.")
            
        } else {
            UserController.updateUser(UserController.sharedController.currentUser!, username: usernameTextField.text!, email: emailTextField.text!, completion: { (user, error) -> Void in
                
            })
        }
        
        
//        
//        UserController.createUser(usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, photo: "", completion: { (user, error) -> Void in
//            if error == nil {
//                self.user = user
//                self.dismissViewControllerAnimated(true, completion: nil)
//            } else {
//                ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
//            }
//        })
        
//        self.tabBarController?.performSegueWithIdentifier("noCurrentUser", sender: nil)
    }
    
    
    @IBAction func deleteAccountTapped(sender: AnyObject) {
        
    }
    
    
    @IBAction func updatePasswordTapped(sender: AnyObject) {
    }
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
    }
    
    @IBAction func updatePhotoTapped(sender: AnyObject) {
        
    }
    
    
    
    // MARK: viewDid Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViewForMode(ViewMode.defaultView)
    }

}
