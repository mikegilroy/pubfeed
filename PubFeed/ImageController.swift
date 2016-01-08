//
//  ImageController.swift
//  PubFeed
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import UIKit

private let bucketKey = "pubfeed-userfiles-mobilehub-827307080/public"

class ImageController {
    
    static func uploadPhoto(photo: UIImage, requestKey: String, completion: (identifier: String?) -> Void) {
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let path = NSTemporaryDirectory().NS.stringByAppendingPathComponent("temp")
        let photoURL = NSURL(fileURLWithPath: path)
        let uploadRequest : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        
        let data = UIImageJPEGRepresentation(photo, 0.4)
        data?.writeToURL(photoURL, atomically: true)
        
        uploadRequest.bucket = bucketKey
        if requestKey == "" {
            completion(identifier: "")
        } else {
            uploadRequest.key = requestKey
            uploadRequest.body = photoURL
            
            let task = transferManager.upload(uploadRequest)
            task.continueWithSuccessBlock { (task) -> AnyObject? in
                if task.error != nil {
                    print("Error: \(task.error)")
                } else {

                        let base = FirebaseController.base.childByAppendingPath("profileImages").childByAutoId()
                        base.setValue("\(photoURL)")
                        completion(identifier: base.key)
                
                    print("Success")
                }
                return nil
            }
        }
    }
    
    static func profilePhotoForIdentifier(identifer: String, user: User, completion: (photoUrl: NSURL?) -> Void) {
        var photoUrl: NSURL?
        FirebaseController.dataAtEndpoint("profileImages/\(identifer)") { (data) -> Void in
            if let data = data as? String {
                photoUrl = NSURL(string: data)
                completion(photoUrl: photoUrl)
            }
        }
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        
        downloadRequest.bucket = bucketKey
        downloadRequest.key = user.identifier! + "png"
        downloadRequest.downloadingFileURL = photoUrl
        
        let task = transferManager.download(downloadRequest)
        task.continueWithSuccessBlock { (task) -> AnyObject? in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                print("Success")
            }
            return nil
        }
    }
    
//    static func photoForIdentifier(identifier: String, completion: (photo: UIImage?) -> Void) {
//        
//        FirebaseController.dataAtEndpoint("photos/\(identifier)") { (data) -> Void in
//            
//            if let data = data as? String {
//                let photo = UIImage(base64: data)
//                completion(photo: photo)
//            }
//        }
//    }
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