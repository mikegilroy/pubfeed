//
//  comment.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

struct Comment: Equatable, FirebaseType {
    
    private let textKey = "text"
    private let userIdentifierKey = "userIdentifier"
    private let postIdentifierKey = "postIdentifier"
    private let identifierKey = "identifier"
    private let timestampKey = "timestamp"
    private let usernameKey = "username"
    private let userPhotoKey = "userPhoto"
    
    var text: String
    var userIdentifier: String
    var postIdentifier: String
    var timestamp: NSDate
    var identifier: String?
    var username: String
    var userPhotoUrl: String?
    
    init(username: String, text: String, userIdentifier: String, userPhotoUrl: String?, postIdentifier: String, timestamp: NSDate, identifier: String? = nil) {
        
        self.text = text
        self.userIdentifier = userIdentifier
        self.postIdentifier = postIdentifier
        self.timestamp = timestamp
        self.identifier = identifier
        self.username = username
        self.userPhotoUrl = userPhotoUrl
   
    }
    
    // Mark: FirebaseType
    var endpoint: String {
        return "comments"
    }
    
    var jsonValue: [String: AnyObject] {
        return [textKey: text, userIdentifierKey: userIdentifier, postIdentifierKey: postIdentifier, timestampKey: timestamp.stringValue(), usernameKey: username]
    }
    
    
    init?(json: [String:AnyObject], identifier: String) {
        print(json)
        print(identifier)
        guard let postIdentifier = json[postIdentifierKey] as? String,
            
            let text = json[textKey] as? String,
            let userIdentifier = json[userIdentifierKey] as? String,
            let timestampString = json[timestampKey] as? String,
            let username = json[usernameKey] as? String,
            let timestamp: NSDate? = timestampString.dateValue() else {
                return nil
        }
        if timestamp == nil {
            return nil
        }
        if let userPhotoUrl = json[userPhotoKey] as? String{
            self.userPhotoUrl = userPhotoUrl
        }
        
        self.postIdentifier = postIdentifier
        self.text = text
        self.userIdentifier = userIdentifier
        self.timestamp = timestamp!
        self.identifier = identifier
        self.username = username
    }
}


func ==(lhs: Comment, rhs: Comment) -> Bool {
    
    return (lhs.identifier == rhs.identifier) && (lhs.timestamp == rhs.timestamp)
}

