//
//  Like.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

struct Like: Equatable, FirebaseType {
    
    private let UserIDKey = "username"
    private let PostIDKey = "post"
    private let IdentifierKey = "identifier"
    
    let userIdentifier: String
    let postIdentifier: String
    let identifier: String?
    
    init(userIdentifier: String, postIdentifier: String, identifier: String? = nil) {
        
        self.userIdentifier = userIdentifier
        self.postIdentifier = postIdentifier
        self.identifier = identifier
    }
    
    
    // Mark: FirebaseType
    
    var endPoint: String {
        
        return "likes"
    }
    
    var jsonValue: [String: AnyObject] {
        
        var json: [String: AnyObject] = [UserIDKey: userIdentifier, PostIDKey: postIdentifier]
        if let identifier = identifier {
            json.updateValue(identifier, forKey: IdentifierKey)
        }
        return json
    }
    
    
    init?(json: [String:AnyObject], identifier: String) {
        
        guard let postIdentifier = json[PostIDKey] as? String,
            
            let userIdentifier = json[UserIDKey] as? String else { return nil }
        
        self.init(userIdentifier: userIdentifier, postIdentifier: postIdentifier, identifier: identifier)
    }
}


func ==(lhs: Like, rhs: Like) -> Bool {
    
    return (lhs.identifier == rhs.identifier) && (lhs.postIdentifier == rhs.postIdentifier)
}
