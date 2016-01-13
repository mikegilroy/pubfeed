//
//  SettingsTableViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
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
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.textColor = UIColor.blackColor()
    }
    
    
    func updateViewForMode(mode: ViewMode) {
        switch mode {
            
        case .defaultView:
            
            if let user = UserController.sharedController.currentUser {
                usernameTextField.text = user.username
                emailTextField.text = user.email
                usernameTextField.userInteractionEnabled = false
                emailTextField.userInteractionEnabled = false
                usernameTextField.textColor = UIColor.blackColor()
                emailTextField.textColor = UIColor.blackColor()
            }
            
            saveButton.enabled = false
            updateProfilePhotoButton.userInteractionEnabled = false
            updateProfilePhotoButton.setTitle("", forState: .Normal)
            updateProfilePhotoButton.alpha = 1
            
            let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editButtonTapped:")
            self.navigationController?.navigationItem.leftBarButtonItem = editButton
            self.navigationItem.setLeftBarButtonItem(editButton, animated: true)
            
            
            
            ImageController.profilePhotoForIdentifier((UserController.sharedController.currentUser?.identifier)!) { (photoUrl) -> Void in
                
                if let photoUrl = photoUrl {
                    ImageController.fetchImageAtUrl(photoUrl, completion: { (image) -> () in
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.updateProfilePhotoButton.setBackgroundImage(image, forState: .Normal)
                        })
                    })
                }
            }
            
        case .editView:
            
            let textFieldGrayColor = colorWithHexString("d4d4d6")
            
            usernameTextField.text = ""
            emailTextField.text = ""
            usernameTextField.userInteractionEnabled = true
            emailTextField.userInteractionEnabled = true
            usernameTextField.enabled = true
            emailTextField.enabled = true
            usernameTextField.textColor = textFieldGrayColor
            emailTextField.textColor = textFieldGrayColor
            
            textFieldDidBeginEditing(usernameTextField)
            textFieldDidBeginEditing(emailTextField)
            
            saveButton.enabled = true
            updateProfilePhotoButton.enabled = true
            updateProfilePhotoButton.alpha = 0.70
            updateProfilePhotoButton.userInteractionEnabled = true
            updateProfilePhotoButton.setTitle("Edit Profile Photo", forState: .Normal)
            updateProfilePhotoButton.titleLabel?.textColor = UIColor.blueColor()
            
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
            ErrorHandling.defaultErrorHandler(nil, title: "Missing Information in both fields.  Please supply missing field.")
            
            if usernameTextField.text == "" {
                usernameTextField.text = UserController.sharedController.currentUser?.username
            }
            
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
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
        
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
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
        
        alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let oldPasswordInput = inputOldPassTextField?.text {
                if let newPasswordInput = inputNewPassTextField?.text {
                    
                    UserController.changePasswordForUser(UserController.sharedController.currentUser!, oldPassword: oldPasswordInput, newPassword: newPasswordInput) { (error) -> Void in
                        if let error = error {
                            ErrorHandling.defaultErrorHandler(error, title: "\(error.localizedDescription)")
                        } else {
                            let successAlertController = UIAlertController(title: "Success!", message: "Your password has been changed.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            successAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
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
        UserController.sharedController.currentUser = nil
        self.performSegueWithIdentifier("fromSettings", sender: nil)
    }
    
    
    @IBAction func updatePhotoTapped(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let dispatchGroup = dispatch_group_create()
        dispatch_group_enter(dispatchGroup)
        
        let photoChoiceAlert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            photoChoiceAlert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            photoChoiceAlert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .Camera
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        photoChoiceAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(photoChoiceAlert, animated: true, completion: nil)
        
        dispatch_group_leave(dispatchGroup)
    }
    
    
    
    //MARK: - Image Picker Controller Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        profilePhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        updateProfilePhotoButton.setBackgroundImage(profilePhoto, forState: .Normal)
        updateProfilePhotoButton.setTitle(nil, forState: .Normal)
        
        if let photo = UserController.sharedController.currentUser?.photo {
            var currentUser = UserController.sharedController.currentUser
            
            //BUG ON UPLOAD HERE
            ImageController.profilePhotoForIdentifier((currentUser!.identifier!), completion: { (photoUrl) -> Void in
                if let photoUrl = photoUrl {
                    ImageController.fetchImageAtUrl(photoUrl, completion: { (var image) -> () in
                        
                        image = self.profilePhoto!
                        
                        ImageController.uploadPhoto(image, completion: { (identifier) -> Void in
                            
                            if identifier != nil {
                                
                                currentUser!.photo = "\(identifier)"
                                
                                //                            self.user!.photo = "\(identifier)"
                                currentUser!.save({ (error) -> Void in
                                    if error == nil {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        })
                                    } else {
                                        ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
                                    }
                                })
                                
                                let successAlert = UIAlertController(title: "Success!", message: "Photo:\(photo) updated.", preferredStyle: .Alert)
                                successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                self.presentViewController(successAlert, animated: true, completion: nil)
                                
                            } else {
                                let failedAlert = UIAlertController(title: "Failed!", message: "Image failed to update. Please try again.", preferredStyle: .Alert)
                                failedAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                self.presentViewController(failedAlert, animated: true, completion: nil)
                            }
                        })
                        
                    })
                }
            })
            
        } else {
            ImageController.uploadPhoto(self.profilePhoto!) { (path) -> Void in
                if let path = path {
                    
                    
                    self.user!.photo = "\(path)"
                    self.user?.save({ (error) -> Void in
                        if error == nil {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let successAlert = UIAlertController(title: "Success!", message: "Photo posted.", preferredStyle: .Alert)
                                successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                self.presentViewController(successAlert, animated: true, completion: nil)
                            })
                        } else {
                            ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
                            let failedAlert = UIAlertController(title: "Failed!", message: "Image failed to post. Please try again.", preferredStyle: .Alert)
                            failedAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                            self.presentViewController(failedAlert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
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
        updateProfilePhotoButton.titleLabel?.text = ""
        self.updateProfilePhotoButton.imageView?.contentMode = .ScaleAspectFill
        
        //textField delegate
        usernameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    
    // MARK: helper funcs
    
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
