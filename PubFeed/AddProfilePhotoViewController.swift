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
    @IBOutlet weak var addProfilePhotoButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var user: User?
    var profilePhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.enabled = false
        
//        addProfilePhotoButton.layer.borderColor = UIColor.darkGrayColor().CGColor
//        addProfilePhotoButton.layer.borderWidth = 1
//        addProfilePhotoButton.layer.cornerRadius = addProfilePhotoButton.frame.size.width/2
        
        let pubGreen = colorWithHexString("6AFF63").CGColor
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackGround")!)
        addProfilePhotoButton.layer.borderWidth = 4
        addProfilePhotoButton.layer.borderColor = pubGreen
        
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
              
                self.user?.photo = "\(path)"
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
            self.addProfilePhotoButton.setImage(self.profilePhoto, forState: .Normal)
//            self.addProfilePhotoButton.setBackgroundImage(, forState: .Normal)
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
