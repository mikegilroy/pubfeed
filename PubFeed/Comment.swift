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
    
    var text: String
    var userIdentifier: String
    var postIdentifier: String
    var identifier: String?
    
    init(text: String, userIdentifier: String, postIdentifier: String, identifier: String? = nil) {
        
        self.text = text
        self.userIdentifier = userIdentifier
        self.postIdentifier = postIdentifier
        self.identifier = identifier
    }
    
    
    // Mark: FirebaseType
    
    var endpoint: String {
        return "comments"
    }
    
    var jsonValue: [String: AnyObject] {
        
        return [textKey: text, userIdentifierKey: userIdentifier, postIdentifierKey: postIdentifier]
    }
    
    
    init?(json: [String:AnyObject], identifier: String) {
        
        guard let postIdentifier = json[postIdentifierKey] as? String,
            
            let text = json[textKey] as? String,
            let userIdentifier = json[userIdentifierKey] as? String else { return nil }
        
        self.postIdentifier = postIdentifier
        self.text = text
        self.userIdentifier = userIdentifier
        self.identifier = identifier
    }
}


func ==(lhs: Comment, rhs: Comment) -> Bool {
    
    return (lhs.identifier == rhs.identifier) && (lhs.postIdentifier == rhs.postIdentifier)
}

