//
//  Post.swift
//  PubFeed
//
//  Created by Jay Maloney on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation

struct Post: Equatable, FirebaseType {
    
    // MARK: Keys
    private let kUserIdentifier = "userIdentifier"
    private let kTimestamp = "timestamp"
    private let kEmojis = "emojis"
    private let kText = "text"
    private let kPhoto = "photo"
    private let kBarID = "barID"
    
    // MARK: Properties
    var userIdentifier: String
    var barID: String
    var timestamp: NSDate
    var emojis: String
    var text: String?
    var photo: String?
    var identifier: String?
    
    // MARK: Initializer
    init(userIdentifier: String, barID: String, timestamp: NSDate, emojis: String, text: String?, photo: String?, identifier: String? = nil) {
        self.userIdentifier = userIdentifier
        self.barID = barID
        self.timestamp = timestamp
        self.emojis = emojis
        self.text = text
        self.photo = photo
        self.identifier = identifier
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "posts"
    }
    
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kUserIdentifier: userIdentifier, kBarID: barID, kTimestamp: timestamp.stringValue(), kEmojis: emojis]
        if let text = text {
            json.updateValue(text, forKey: kText)
        }
        if let photo = photo {
            json.updateValue(photo, forKey: kPhoto)
        }
        return json
    }
    
    
    init?(json: [String : AnyObject], identifier: String) {
        guard let userIdentifier = json[kUserIdentifier] as? String,
            let barID = json[kBarID] as? String,
            let timestampString = json[kTimestamp] as? String,
            let timestamp: NSDate? = timestampString.dateValue(),
            let emojis = json[kEmojis] as? String else {
                return nil
        }
        if timestamp == nil {
            return nil
        }
        self.userIdentifier = userIdentifier
        self.barID = barID
        self.timestamp = timestamp!
        self.emojis = emojis
        if let text = json[kText] as? String {
            self.text = text
        }
        if let photo = json[kPhoto] as? String {
            self.photo = photo
        }
        self.identifier = identifier
    }
}

func ==(lhs: Post, rhs: Post) -> Bool {
    
    return (lhs.identifier == rhs.identifier) && (lhs.timestamp == rhs.timestamp)
}