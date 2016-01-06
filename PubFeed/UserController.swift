//
//  UserController.swift
//  PubFeedDemoCode
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    
    static var shareController = UserController()
    
    private let UserKey = "user"
    
    static let sharedController = UserController()
    
//    var currentUser: User! {
//        get {
//            
//            guard let uid = FirebaseController.base.authData?.uid,
//                let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(UserKey) as? [String: AnyObject] else {
//                    
//                    return nil
//            }
//            
//            return User(json: userDictionary, identifier: uid)
//        }
//        
//        set {
//            
//            if let newValue = newValue {
//                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: UserKey)
//                NSUserDefaults.standardUserDefaults().synchronize()
//            } else {
//                NSUserDefaults.standardUserDefaults().removeObjectForKey(UserKey)
//                NSUserDefaults.standardUserDefaults().synchronize()
//            }
//        }
//    }
//
//    static func createUser(username: String, email: String, password: String, photo: UIImage, completion: (user: User?, error: NSError?) -> Void) {
    
//        FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
//            
//            if let uid = response["uid"] as? String {
//                var user = User(username: username, email: email, photo: photo, uid: uid)
//                user.save()
//                
//                authenticateUser(email, password: password, completion: { (success, user) -> Void in
//                    completion(success: success, user: user)
//                })
//            }
//        }
        
//    }
    
//    static func authenticateUser(email: String, password: String, completion: (user: User?, error: NSError?) -> Void) {

//        FirebaseController.base.authUser(email, password: password) { (error, response) -> Void in
//            
//            if error != nil {
//                completion(user: nil, error: error)
//                print("Unsuccessful login attempt.")
//            } else {
//                print("User ID: \(response.uid) authenticated successfully.")
//                
//                UserController.userWitIdentifier(response.uid, completion: { (user) -> Void in
//                    
//                    if let user = user {
//                        
//                        sharedController.currentUser = user
//                    }
//                    
//                    completion(user: user, error: nil)
//                })
//            }
//        }
//    }

//    static func userWithIdentifier(uid: String, completion: (user: User?) -> Void) {
////        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) -> Void in
////            
////            if let json = data as? [String: AnyObject] {
////                let user = User(json: json, identifier: identifier)
////                completion(user: user)
////            } else {
////                completion(user: nil)
////            }
////        }
//    }
//    
//    static func updateUser(user: User, username: String, email: String, password: String, completion: (user: User?) -> Void)  {
//        
////        var updatedUser = User(username: user.username, email: user.email, photo: user.photo, uid: user.identifier!)
////        user.password = password
////        user.save()
////        updatedUser.save()
////        
////        UserController.userForIdentifier(user.identifier!) { (user) -> Void in
////            
////            if let user = user {
////                
////                sharedController.currentUser = user
////            }
////            
////            completion(success: true, user: user)
////        }
//    }
//    
//    static func logoutUser() {
////        FirebaseController.base.unauth()
////        sharedController.currentUser = nil
//    }
//
//    static func deleteUser(user: User, password: String, completion: (success: Bool) -> Void) {
//        
//    }


}