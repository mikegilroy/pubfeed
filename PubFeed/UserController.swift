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
    
    private let UserKey = "user"

    static let sharedController = UserController()
    
    var currentUser: User? {
        get {
            guard let uid = FirebaseController.base.authData?.uid,
                let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(UserKey) as? [String: AnyObject] else {
                    return nil
            }
            return User(json: userDictionary, identifier: uid)
        }
        set {
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: UserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(UserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    //AUTH & UNAUTH

    static func authenticateUser(email: String, password: String, completion: (user: User?, error: NSError?) -> Void) {
        FirebaseController.base.authUser(email, password: password) { (error, response) -> Void in
            if error != nil {
                completion(user: nil, error: error)
            } else {
                UserController.userWithIdentifier(response.uid, completion: { (user) -> Void in
                    if let user = user {
                        sharedController.currentUser = user
                    }
                    completion(user: user, error: nil)
                })
            }
        }
    }
    
    static func logoutUser() {
        FirebaseController.base.unauth()
        sharedController.currentUser = nil
    }
    
    // CREATE
    static func createUser(username: String, email: String, password: String, photo: String?, completion: (user: User?, createError: NSError?, authError: NSError?) -> Void) {
        FirebaseController.base.createUser(email, password: password) { (createError, response) -> Void in
            if let uid = response["uid"] as? String {
                var user = User(username: username, email: email, photo: photo, uid: uid)
                user.save()
                authenticateUser(email, password: password, completion: { (user, authError) -> Void in
                    completion(user: user, createError: createError, authError: authError)
                })
            }
        }
    }
    
    // READ
    static func userWithIdentifier(uid: String, completion: (user: User?) -> Void) {
        FirebaseController.dataAtEndpoint("users/\(uid)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: uid)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    

    static func updateUser(user: User, username: String, email: String, completion: (user: User?) -> Void)  {
        if let identifier = user.identifier {
            var updatedUser = User(username: user.username, email: user.email, photo: user.photo, uid: identifier)
            updatedUser.save()
            UserController.userWithIdentifier(identifier) { (user) -> Void in
                if let user = user {
                    sharedController.currentUser = user
                    completion(user: user)
                } else {
                    completion(user: nil)
                }
            }
        } else {
            completion(user: nil)
        }
    }
    
    static func changePasswordForUser(user: User, oldPassword: String, newPassword: String, completion: (error: NSError?) -> Void) {
        FirebaseController.base.changePasswordForUser(user.email, fromOld: oldPassword, toNew: newPassword) { (error) -> Void in
            if let error = error {
                completion(error: error)
            } else {
                completion(error: nil)
            }
        }
    }

    
    // UPDATE
    static func updateUser(user: User, username: String, email: String, password: String, completion: (user: User?) -> Void)  {
        if let identifier = user.identifier {
            var updatedUser = User(username: user.username, email: user.email, photo: user.photo, uid: identifier)
            updatedUser.save()
            UserController.userWithIdentifier(identifier) { (user) -> Void in
                if let user = user {
                    sharedController.currentUser = user
                }
                completion(user: user)
            }
        }
    }
    

    // DELETE
    // Needs to also delete likes, comments, and images for that user

    static func deleteUser(user: User, password: String, completion: (success: Bool) -> Void) {
        FirebaseController.base
            .removeUser(user.email, password: password) { (error) -> Void in
                if error == nil {
                    user.delete()
                    PostController.postsForUser(user) { (posts) -> Void in
                        for post in posts {
                            post.delete()
                            completion(success: true)
                        }
                    }
                }
        }
    }
    
    static func mockUsers() -> [User] {
        
        let user1 = User(username: "Thang", email: "thang@yahoo.com", photo: nil)
        let user2 = User(username: "James", email: "jame@yahoo.com", photo: nil, uid: "ojdoisjvijcxv")
        let user3 = User(username: "Jay", email: "Jay@YAHOO.com", photo: "abc", uid: "abcdef")
        
        return [user1, user2, user3]
    }
    
    
}