//
//  SignupViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    var profilePhoto: UIImage?
    var user: User?
    var profilePhotoIdentifier: String?
    
    // MARK: Outlet
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addProfilePhotoButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func addProfilePhotoButtonTapped(sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Selection Alert
        let avatarAlert = UIAlertController(title: "Select avatar location", message: nil, preferredStyle: .ActionSheet)
        
        // Library Picker
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            avatarAlert.addAction(UIAlertAction(title: "Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        // Camera
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            avatarAlert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        avatarAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(avatarAlert, animated: true, completion: nil)
        })
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        
        if (usernameTextField.text == "") || (emailTextField.text == "") || (passwordTextField.text == "") {
            ErrorHandling.defaultErrorHandler(nil, title: "Missing Information")
        } else {
            /*
            //User With Photo
            
            if let profilePhoto = self.profilePhoto {
            UserController.createUser(usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, photo: profilePhoto, completion: { (user, error) -> Void in
            if error == nil {
            self.user = user
            self.dismissViewControllerAnimated(true, completion: nil)
            } else {
            ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
            }
            })
            } else {
            
            // If user has no photo
            
            UserController.createUser(usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, photo: UIImage(), completion: { (user, error) -> Void in
            if error == nil {
            self.user = user
            self.dismissViewControllerAnimated(true, completion: nil)
            } else {
            ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
            }
            })
            }
            }
            */
            
            UserController.createUser(usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, photo: UIImage(), completion: { (user, error) -> Void in
                if error == nil {
                    self.user = user
                    self.dismissViewControllerAnimated(true, completion: nil)
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
    
    // MARK: UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.profilePhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.addProfilePhotoButton.setBackgroundImage(self.profilePhoto, forState: .Normal)
        })
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //        if segue.identifier == "fromSignUp" {
        //            if let destinationController = segue.destinationViewController as? MapViewController {
        //                _ = destinationController.view
        //
        //                destinationController.user = self.user
        //            }
        //        }
    }
    
}
