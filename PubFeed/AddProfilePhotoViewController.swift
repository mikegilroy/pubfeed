//
//  AddProfilePhotoViewController.swift
//  PubFeed
//
//  Created by Thang H Tong on 1/8/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import UIKit

class AddProfilePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var submitButton: UIButton!
    var user: User?
    var profilePhoto: UIImage?
    @IBOutlet weak var addProfilePhotoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.enabled = false
        // Do any additional setup after loading the view.
    }
    
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
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        ImageController.uploadPhoto(self.profilePhoto!) { (path) -> Void in
            if let path = path {
            
                self.user!.photo = "\(path)"
                self.user?.save({ (error) -> Void in
                    if error == nil {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                             self.performSegueWithIdentifier("toFirstTabView", sender: nil)
                        })
                       
                    } else {
                        ErrorHandling.defaultErrorHandler(error, title: "\(error!.localizedDescription)")
                    }
                })
            }
        }
    }
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        self.performSegueWithIdentifier("toFirstTabView", sender: nil)
    }
    
    // MARK: UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.profilePhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.submitButton.enabled = true
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.addProfilePhotoButton.setBackgroundImage(self.profilePhoto, forState: .Normal)
            self.addProfilePhotoButton.setTitle("", forState: .Normal)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFirstTabView" {
        if let destinationController = segue.destinationViewController as? MapViewController {
            _ = destinationController.view
                destinationController.user = self.user
            }
        }
    }
}
