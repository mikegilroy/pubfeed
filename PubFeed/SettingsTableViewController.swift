//
//  SettingsTableViewController.swift
//  PubFeed
//
//  Created by Mike Gilroy on 06/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // MARK: Keys
    private let kPhoto = "photo"
    
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
    
    
    // MARK: ViewMode Case Declarations
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
    @IBOutlet var tableViewMain: UITableView!
    @IBOutlet weak var usernameLine: UIView!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    // MARK: Alert Controller Declaration
    func presentValidationAlertWithTitle(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: View Functions
    func updateViewForMode(mode: ViewMode) {
        
        switch mode {
            // MARK: Default View Case
        case .defaultView:
            
            let defaultTextGrey = colorWithHexString("3c3c3c")
            
            // MARK: NSUserDefaults Loader, loads and sets local
            if let imageData = NSUserDefaults.standardUserDefaults().objectForKey(self.kPhoto) as? NSData {
                let image = UIImage(data: imageData)
  
                self.profileImageView.image = image
            }
            
            if let user = UserController.sharedController.currentUser {
                usernameTextField.text = user.username
                emailTextField.text = user.email
                usernameTextField.userInteractionEnabled = false
                emailTextField.userInteractionEnabled = false
                usernameTextField.textColor = defaultTextGrey
                emailTextField.textColor = defaultTextGrey
            }
            
            saveButton.enabled = false
            
            profileImageView.alpha = 1.0
            
            updateProfilePhotoButton.userInteractionEnabled = false
            updateProfilePhotoButton.setTitle("", forState: .Normal)
            updateProfilePhotoButton.alpha = 0.0
            
            // MARK: Edit Mode Bar Button Declaration/Instantiation
            let editButton = UIBarButtonItem(image: UIImage(named: "editButton"), style: .Plain, target: self, action: "editButtonTapped:")
            self.navigationController?.navigationItem.leftBarButtonItem = editButton
            self.navigationItem.setLeftBarButtonItem(editButton, animated: true)
            
            ImageController.profilePhotoForIdentifier((UserController.sharedController.currentUser?.identifier)!) { (photoUrl) -> Void in
                if let photoUrl = photoUrl {
                    ImageController.fetchImageAtUrl(photoUrl, completion: { (image) -> () in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.profileImageView.image = image
                        })
                    })
                    
                } else {
                    
                    if let imageData = NSUserDefaults.standardUserDefaults().objectForKey(self.kPhoto) as? NSData {
                        let image = UIImage(data: imageData)
                        
                        self.profileImageView.image = image
                    }
                }
            }
            
            // MARK: Edit View Case
        case .editView:
            
            usernameTextField.text = UserController.sharedController.currentUser?.username
            emailTextField.text = UserController.sharedController.currentUser?.email
            usernameTextField.userInteractionEnabled = true
            emailTextField.userInteractionEnabled = true
            usernameTextField.enabled = true
            emailTextField.enabled = true
            usernameTextField.textColor = UIColor.lightGrayColor()
            emailTextField.textColor = UIColor.lightGrayColor()
            
            saveButton.enabled = true
            
            updateProfilePhotoButton.enabled = true
            updateProfilePhotoButton.alpha = 0.8
            updateProfilePhotoButton.userInteractionEnabled = true
            updateProfilePhotoButton.setTitle("EDIT PHOTO", forState: .Normal)
            
            profileImageView.alpha = 0.15
            
            let cancelButton = UIBarButtonItem(title: "X", style: .Plain, target: self, action: "editButtonTapped:")
            self.navigationController?.navigationItem.leftBarButtonItem = cancelButton
            self.navigationItem.setLeftBarButtonItem(cancelButton, animated: true)
        }
    }
    
    
    // MARK: Edit Button Tapped
    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        
        if let buttonAppearance = sender.image {
            switch buttonAppearance {
            case UIImage(named: "editButton")!:
                self.mode = .editView
                updateViewForMode(mode)
            case "X":
                self.mode = .defaultView
                updateViewForMode(mode)
            default:
                updateViewForMode(mode)
            }
        }
        if let buttonTitle = sender.title {
            switch buttonTitle {
            case "X":
                self.mode = .defaultView
                updateViewForMode(mode)
            default:
                updateViewForMode(mode)
            }
        }
    }
    
    
    // MARK: Save Button Tapped
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        
        if (usernameTextField.text == "") || (emailTextField.text == "") {
            ErrorHandling.defaultErrorHandler(nil, title: "Missing Information in both fields.  Please supply missing field.")
            
        } else {
            
            UserController.updateUser(UserController.sharedController.currentUser!, username: usernameTextField.text!, email: emailTextField.text!, completion: { (user, error) -> Void in
                
                if let user = UserController.sharedController.currentUser {
                    
                    self.presentValidationAlertWithTitle("Success!", text: "Thank you, \(user.username), your account at \(user.email) has been updated.")
                    
                    if error == nil {
                        self.updateViewForMode(ViewMode.defaultView)
                    }
                    
                } else {
                    ErrorHandling.defaultErrorHandler(error, title: "\(error?.localizedDescription)")
                }
            })
        }
        self.updateViewForMode(ViewMode.defaultView)
    }
    
    
    // MARK: Delete Button Tapped
    @IBAction func deleteAccountTapped(sender: AnyObject) {
        var inputTextField: UITextField?
        let alertController = UIAlertController(title: "Are you sure you want to delete your account?", message: "Please enter password.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in }))
        
        alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let userPasswordInput = inputTextField?.text {
                
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
    
    
    //MARK: Update Password Tapped
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
    
    
    // MARK: Logout Tapped
    @IBAction func logoutTapped(sender: AnyObject) {
        FirebaseController.base.unauth()
        UserController.sharedController.currentUser = nil
        self.performSegueWithIdentifier("fromSettings", sender: nil)
    }
    
    
    // MARK: Update Photo Tapped
    @IBAction func updatePhotoTapped(sender: AnyObject) {
        
        // MARK: Image Picker Delegate
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let dispatchGroup = dispatch_group_create()
        dispatch_group_enter(dispatchGroup)
        
        let photoChoiceAlert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .ActionSheet)
        
        // MARK: Photo Library Source
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            photoChoiceAlert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        // MARK: Camera Source
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
        
        if let identifier = UserController.sharedController.currentUser?.identifier {
            
            self.profilePhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            self.profileImageView.image = profilePhoto

            let successAlertController = UIAlertController(title: "Update Photo?", message: "Press Ok or Cancel.", preferredStyle: UIAlertControllerStyle.Alert)
            successAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
                self.updateViewForMode(ViewMode.defaultView)
            }))
            
            successAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                ImageController.updateProfilePhoto(identifier, image: self.profilePhoto!, completion: { (success, error) -> Void in
                    
                    if success == true {
                        let imageData : NSData = UIImageJPEGRepresentation(self.profilePhoto!, (0.7))!
                        NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: self.kPhoto)
                        
                        let successAlertController = UIAlertController(title: "Success!", message: "Photo updated.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        successAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            self.updateViewForMode(ViewMode.defaultView)
                        }))
                        self.presentViewController(successAlertController, animated: true, completion: nil)
                    } else {
                        ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
                    }
                })
            }))
            self.presentViewController(successAlertController, animated: true, completion: nil)
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
    
    
    // MARK: ProfilePhotoLoader
    func viewDidLoadProfilePhotoLoader(completion: (success: Bool) -> Void)  {
        if let identifier = UserController.sharedController.currentUser?.identifier {
            
            ImageController.profilePhotoForIdentifier(identifier) { (photoUrl) -> Void in
                
                if let url = photoUrl {
                    ImageController.fetchImageAtUrl(url, completion: { (image) -> () in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.updateProfilePhotoButton.layer.borderWidth = 1.0
                            self.updateProfilePhotoButton.layer.cornerRadius = self.updateProfilePhotoButton.frame.size.width/2
                            
                            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
                            
                            if let image = image {
                                self.profileImageView.image = image
                          
                            } else {
                                print("no asset")
                            }
                        })
                    })
                }
            }
        } else {
            print("No Photo ID, cannot load photo assets in current view.")
            
            // MARK: NSUserDefaults Loader, loads and sets local in case of Network error.
            if let imageData = NSUserDefaults.standardUserDefaults().objectForKey(self.kPhoto) as? NSData {
                let image = UIImage(data: imageData)
                
                self.profileImageView.image = image
            }
        }
    }
    
    
    // MARK: viewDidLoad Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLoadProfilePhotoLoader { (success) -> Void in
            if success {
                print("viewDidLoadProfileLoader success")
            } else {
                print("nil")
            }
        }
        
        // MARK: TextField Delegates
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        
        self.updateViewForMode(ViewMode.defaultView)
    }
    
    
    // MARK: viewDidAppear Functions
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BarController.sharedController.currentBar = nil
    }
    
    
    // MARK: Text Delegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.textColor = UIColor.darkGrayColor()
    }
    
    
    // MARK: UI Helpers
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