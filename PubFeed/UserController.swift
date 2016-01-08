//
//  UserController.swift
//  PubFeedDemoCode
//
//  Created by Thang H Tong on 1/6/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import Foundation
import UIKit
import Firebase


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

    
    // Login/Signup Views implemented
    
    static func authenticateUser(email: String, password: String, completion: (user: User?, error: NSError?) -> Void) {
        FirebaseController.base.authUser(email, password: password) { (error, response) -> Void in
            if let error = error {
                completion(user: nil, error: error)
            } else {
                UserController.userWithIdentifier(response.uid, completion: { (user) -> Void in
                    if let user = user {
                        sharedController.currentUser = user
                        completion(user: user, error: nil)
                    } else {
                        completion(user: nil, error: Error.defaultError())
                    }
                })
            }
        }
    }
    
    static func logoutUser() {
        FirebaseController.base.unauth()
        sharedController.currentUser = nil
    }
    
    // CREATE
    
    static func createUser(username: String, email: String, password: String, completion: (user: User?, error: NSError?) -> Void) {
  
        FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
            if let uid = response["uid"] as? String {
                var user = User(username: username, email: email, uid: uid)
                user.save({ (error) -> Void in
                    if error != nil {
                        completion(user: nil, error: error)
                    } else {
                        authenticateUser(email, password: password, completion: { (user, error) -> Void in
                            if let user = user {
                                completion(user: user, error: nil)
                            } else {
                                completion(user: nil, error: error)
                            }
                        })
                    }
                })
            } else {
                completion(user: nil, error: error)
            }
        }
    }
    
    
    
    
    //    static func createUser(username: String, email: String, password: String, photo: String?, completion: (user: User?, createError: NSError?, authError: NSError?) -> Void) {
    //        FirebaseController.base.createUser(email, password: password) { (createError, response) -> Void in
    //            if let uid = response["uid"] as? String {
    //                var user = User(username: username, email: email, photo: photo, uid: uid)
    //                user.save()
    //                authenticateUser(email, password: password, completion: { (user, authError) -> Void in
    //                    completion(user: user, createError: createError, authError: authError)
    //                })
    //            }
    //        }
    //    }
    
    
    // READ
    static func userWithIdentifier(uid: String, completion: (user: User?) -> Void) {
        FirebaseController.dataAtEndpoint("users/\(uid)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: uid)
                completion(user: user)
            }
        }
    }
    
    // UPDATE
    static func updateUser(user: User, username: String, email: String, completion: (user: User?, error: NSError?) -> Void)  {
        //does this update both users? CHECK
        if let identifier = user.identifier {
            var updatedUser = User(username: user.username, email: user.email, photo: user.photo, uid: identifier)
            updatedUser.save({ (error) -> Void in
                if let error = error {
                    completion(user: nil, error: error)
                } else {
                    UserController.userWithIdentifier(identifier) { (user) -> Void in
                        if let user = user {
                            sharedController.currentUser = user
                            completion(user: user, error: nil)
                        } else {
                            completion (user: nil, error: Error.defaultError())
                        }
                    }
                }
            })
        } else {
            completion(user: nil, error: Error.defaultError())
        }
    }
    
    static func changePasswordForUser(user: User, oldPassword: String, newPassword: String, completion: (error: NSError?) -> Void) {
        FirebaseController.base.changePasswordForUser(user.email, fromOld: oldPassword, toNew: newPassword) { (error) -> Void in
            if let error = error {
                completion(error: error)
            }
        }
    }
    
    // DELETE
    
    // Needs to also delete images for that user
    static func deleteUser(user: User, password: String, completion:(errors: [NSError]?) -> Void) {
        var errorArray: [NSError] = []
        PostController.deleteAllPostsForUser(user) { (errors) -> Void in
            if let errors = errors {
                for error in errors {
                    errorArray.append(error)
                }
            }
        }
        CommentController.deleteAllCommentsForUser(user) { (error) -> Void in
            if let error = error {
                errorArray.append(error)
            }
        }
        LikeController.deleteAllLikesForUser(user) { (error) -> Void in
            if let error = error {
                errorArray.append(error)
            }
        }
        FirebaseController.base.removeUser(user.email, password: password) { (error) -> Void in
            if let error = error {
                errorArray.append(error)
            } else {
                user.delete({ (error) -> Void in
                    if let error = error {
                        errorArray.append(error)
                    }
                })
            }
        }
        if errorArray.count == 0 {
            completion(errors: nil)
        } else {
            completion(errors: errorArray)
        }
    }
    
    static func mockUsers() -> [User] {
        let user1 = User(username: "Thang", email: "thang@yahoo.com", photo: nil)
        let user2 = User(username: "James", email: "jame@yahoo.com", photo: nil, uid: "ojdoisjvijcxv")
        let user3 = User(username: "Jay", email: "Jay@YAHOO.com", photo: "abc", uid: "abcdef")
        
        return [user1, user2, user3]
    }
    
    
}