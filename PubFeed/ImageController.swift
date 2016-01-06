//
//  ImageController.swift
//  PubFeed
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    
    static func uploadPhoto(photo: UIImage, completion: (identifier: String?) -> Void) {
        
        if let base64Image = photo.base64String {
            let base = FirebaseController.base.childByAppendingPath("images").childByAutoId()
            base.setValue(base64Image)
            
            completion(identifier: base.key)
        } else {
            completion(identifier: nil)
        }
    }
    
    static func photoForIdentifier(identifier: String, completion: (photo: UIImage?) -> Void) {
        
        FirebaseController.dataAtEndpoint("photos/\(identifier)") { (data) -> Void in
            
            if let data = data as? String {
                let photo = UIImage(base64: data)
                completion(photo: photo)
            }
        }
    }
}

extension UIImage {
    
    var base64String: String? {
        
        guard let data = UIImageJPEGRepresentation(self, 0.8) else {
            
            return nil
        }
        
        return data.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
    
    convenience init?(base64: String) {
        
        if let photoData = NSData(base64EncodedString: base64, options: .IgnoreUnknownCharacters) {
            self.init(data: photoData)
        } else {
            return nil
        }
    }
}