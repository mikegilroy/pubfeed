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
private let AWSUrl = "s3.amazonaws.com"

class ImageController {
    
    
    
    static func uploadPhoto(photo: UIImage, requestKey: String, completion: (String?) -> Void) {
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".jpg")
        
        let path = NSTemporaryDirectory().NS.stringByAppendingPathComponent(fileName)
        let photoURL = NSURL(fileURLWithPath: path)
        let uploadRequest : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
                  let data = UIImageJPEGRepresentation(photo, 0.4)
        data?.writeToURL(photoURL, atomically: true)
        
        uploadRequest.bucket = bucketKey
        if requestKey == "" {
            completion("")
        } else {
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
    }
    

    
    static func profilePhotoForIdentifier(identifier: String, user: User, completion: (photoUrl: NSURL) -> Void) {
        
        FirebaseController.dataAtEndpoint("profileImages/\(identifier)") { (data) -> Void in
            if let data = data as? String {
               let photoUrl = NSURL(string: data)
              completion(photoUrl: photoUrl!)
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