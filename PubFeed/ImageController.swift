//
//  ImageController.swift
//  PubFeed
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import UIKit

private let bucketKey = "profilephotopubfeed"
private let AWSUrl = "https://s3.amazonaws.com"

class ImageController {
    
    static func uploadPhoto(photo: UIImage, completion: (String?) -> Void) {
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".jpg")
        
        let path = NSTemporaryDirectory().NS.stringByAppendingPathComponent(fileName)
        let photoURL = NSURL(fileURLWithPath: path)
        let uploadRequest : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        let data = UIImageJPEGRepresentation(photo, 0.4)
        data?.writeToURL(photoURL, atomically: true)
        
        uploadRequest.bucket = bucketKey
        
        uploadRequest.key = fileName
        uploadRequest.body = photoURL
        print(uploadRequest)
        let task = transferManager.upload(uploadRequest)
        task.continueWithBlock({ (task) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
                completion("")
            } else {
                completion("\(AWSUrl)/\(bucketKey)/\(fileName)")
                print("Success")
            }
            return nil
        })
    }
    
    static func updateProfilePhoto(identifier: String, image: UIImage, completion: (success: Bool, error: NSError?) -> Void) {
        if let user = UserController.sharedController.currentUser {
            var currentUser = user
            ImageController.profilePhotoForIdentifier((user.identifier!), completion: { (photoUrl) -> Void in
               
                    ImageController.uploadPhoto(image, completion: { (identifier) -> Void in
                        if let identifier = identifier {
                            currentUser.photo = "\(identifier)"
                            currentUser.save({ (error) -> Void in
                                
                                if error == nil {
                                    completion(success: true, error: nil)
                                } else {
                                    completion(success: false, error: Error.defaultError())
                                }
                            })
                        }
                    })
            })
        } else {
            print("no user")
        }
    }
    
    
    static func profilePhotoForIdentifier(identifier: String, completion: (photoUrl: NSURL?) -> Void) {

        
        FirebaseController.dataAtEndpoint("users/\(identifier)/photo") { (data) -> Void in
            if let data = data as? String {
                let photoUrl = NSURL(string: data)
                completion(photoUrl: photoUrl)
            } else {
                completion(photoUrl: nil)
                print("no url data")
            }
        }
    }
    
    
    static func postPhotoForIdentifier(postPhotoEndPoint: String, post: Post, completion: (postPhotoUrl: NSURL) -> Void) {
        FirebaseController.dataAtEndpoint("postImages/\(postPhotoEndPoint)") { (data) -> Void in
            if let data = data as? String {
                let postPhotoUrl = NSURL(string: data)
                completion(postPhotoUrl: postPhotoUrl!)
            } else {
                print("no data")
            }
        }
    }
    
    static func fetchImageAtUrl(url: NSURL, completion: (image: UIImage) -> ()) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.URLCache = NSURLCache.sharedURLCache()
        config.requestCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        
        let session = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let data = data {
                let image = UIImage(data: data)
                completion(image: image!)
            } else {
                print("no data")
                print(error?.localizedDescription)
            }
        }
        session.resume()
        
    }
    
    
}




public extension String {
    var NS: NSString { return (self as NSString) }
}

//extension UIImage {
//
//    var base64String: String? {
//
//        guard let data = UIImageJPEGRepresentation(self, 0.8) else {
//
//            return nil
//        }
//
//        return data.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
//    }
//
//    convenience init?(base64: String) {
//
//        if let photoData = NSData(base64EncodedString: base64, options: .IgnoreUnknownCharacters) {
//            self.init(data: photoData)
//        } else {
//            return nil
//        }
//    }
//}