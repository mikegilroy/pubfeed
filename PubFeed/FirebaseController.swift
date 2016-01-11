//
//  FirebaseController.swift
//  PubFeed
//
//  Created by Edward Suczewski on 1/6/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    // MARK: Properties
    static let base = Firebase(url: "https://pubfeed.firebaseio.com")
    
    // MARK: Methods
    static func dataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        baseForEndpoint.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
    static func observeDataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        baseForEndpoint.observeEventType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
}

// MARK: Protocol - FirebaseType
protocol FirebaseType {
    var identifier: String? { get set }
    var endpoint: String { get }
    var jsonValue: [String: AnyObject] { get }
    
    init?(json: [String: AnyObject], identifier: String)
    
    mutating func save(completion: (error: NSError?) -> Void)
    mutating func saveWithLocation(location: CLLocation, completion: (error: NSError?) -> Void)
    mutating func delete(completion: (error: NSError?) -> Void)
}

extension FirebaseType {
    
    mutating func save(completion: (error: NSError?) -> Void) {
        var endpointBase: Firebase
        // When GeoFire is implemented, this should check to see if the object being saved is a post (i.e. by its endpoint). If a post, this this function should add some geofire stuff to it.
        if let childID = self.identifier {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(childID)
        } else {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAutoId()
            self.identifier = endpointBase.key
        }
        endpointBase.updateChildValues(self.jsonValue) { (error, _) -> Void in
            completion(error: error)
        }
    }
    
    mutating func saveWithLocation(location: CLLocation, completion: (error: NSError?) -> Void) {
        var endpointBase: Firebase
        if let childID = self.identifier {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(childID)
        } else {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAutoId()
            self.identifier = endpointBase.key
        }
        let key = self.identifier
        let firebaseRef = FirebaseController.base.childByAppendingPath(endpoint)
        let geoFire = GeoFire(firebaseRef: firebaseRef)
        geoFire.setLocation(location, forKey: key)
        
        endpointBase.updateChildValues(self.jsonValue) { (error, _) -> Void in
            if let error = error {
                completion(error: error)
            } else {
                completion(error: nil)
            }
        }
        
    }
    
    
    func delete(completion: (error: NSError?) -> Void) {
            let endpointBase: Firebase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(self.identifier)
            endpointBase.removeValueWithCompletionBlock { (error, _) -> Void in
                completion(error: error)
        }
    }
}

