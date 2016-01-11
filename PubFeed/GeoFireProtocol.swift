//
//  GeoFireProtocol.swift
//  GeoFireTest
//
//  Created by Edward Suczewski on 1/11/16.
//  Copyright © 2016 Edward Suczewski. All rights reserved.
//

import Foundation
import Firebase

// MARK: Protocol - FirebaseType
protocol GeoFireType {
    var identifier: String? { get set }
    var endpoint: String { get }
    var jsonValue: [String: AnyObject] { get }
    
    init?(json: [String: AnyObject], identifier: String)
    
    mutating func saveWithLocation(location: CLLocation, completion: (error: NSError?) -> Void)
    mutating func delete(completion: (error: NSError?) -> Void)
}

extension GeoFireType {
    
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
