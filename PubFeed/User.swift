//
//  User.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

struct User { // Equatable, FirebaseType
    
    // MARK: Keys
    private let kUsername = "username"
    private let kEmail = "email"
    private let kPhoto = "photo"
    
    // MARK: Properties
    var username: String
    var email: String
    var photo: String?
    var uid: String?
    
    // MARK: Initializer
    init(username: String, email: String, photo: String?, uid: String? = nil) {
        self.username = username
        self.email = email
        self.photo = photo
        self.uid = uid
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "users"
    }
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kUsername: username, kEmail: email]
        if let photo = photo {
            json.updateValue(photo, forKey: kPhoto)
        }
        return json
    }
    
    init?(json: [String : AnyObject], uid: String) {
        guard let username = json[kUsername] as? String,
            let email = json[kEmail] as? String else {
                return nil
        }
        self.username = username
        self.email = email
        if let photo = json[kPhoto] as? String {
            self.photo = photo
        }
        self.uid = uid
    }
    
}

