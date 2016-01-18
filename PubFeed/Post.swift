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
    private let kLikesCount = "likes"
    private let kCommentsCount = "comments"
    private let kLatitude = "latitude"
    private let kLongitude = "longitude"
    
    // MARK: Properties
    var userIdentifier: String
    var barID: String
    var timestamp: NSDate
    var emojis: String
    var text: String?
    var photo: String?
    var identifier: String?
    var likes: Int
    var comments: Int
    var latitude: Double
    var longitude: Double
    
    // MARK: Initializer
    init(userIdentifier: String, barID: String, timestamp: NSDate, emojis: String, text: String?, photo: String?, identifier: String? = nil, likes: Int, comments: Int, latitude: Double, longitude: Double) {
        self.userIdentifier = userIdentifier
        self.barID = barID
        self.timestamp = timestamp
        self.emojis = emojis
        self.text = text
        self.photo = photo
        self.identifier = identifier
        self.likes = likes
        self.comments = comments
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: FirebaseType
    var endpoint: String {
        return "posts"
    }
    
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kUserIdentifier: userIdentifier, kBarID: barID, kTimestamp: timestamp.doubleValue(), kEmojis: emojis, kLikesCount:likes, kCommentsCount:comments, kLatitude:latitude, kLongitude:longitude]
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
            let timestampDouble = json[kTimestamp] as? Double,
            let emojis = json[kEmojis] as? String,
            let likes = json[kLikesCount] as? Int,
            let comments = json[kCommentsCount] as? Int,
            let latitude = json[kLatitude] as? Double,
            let longitude = json[kLongitude] as? Double else {
                return nil
        }

        print("Timestamp date: \(timestampDouble.dateValue()) with doubleValue: \(timestampDouble) ")
        
        self.timestamp = timestampDouble.dateValue()
        self.userIdentifier = userIdentifier
        self.barID = barID
        self.emojis = emojis
        if let text = json[kText] as? String {
            self.text = text
        }
        if let photo = json[kPhoto] as? String {
            self.photo = photo
        }
        self.identifier = identifier
        self.likes = likes
        self.comments = comments
        self.latitude = latitude
        self.longitude = longitude
    }
}

func ==(lhs: Post, rhs: Post) -> Bool {
    
    return (lhs.identifier == rhs.identifier) && (lhs.timestamp == rhs.timestamp)
}
