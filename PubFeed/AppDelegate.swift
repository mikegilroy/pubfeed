//
//  AppDelegate.swift
//  PubFeed
//
//  Created by Mike Gilroy on 05/01/2016.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        if UserController.sharedController.currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            if let window = window {
                window.rootViewController = rootVC
            }
        }

        
        // Override point for customization after application launch.
        
        let identityPoolId = "us-east-1:fc3aaefd-0d46-475f-b882-a58a5b29c42b"
        let unauthRoleArn = "arn:aws:iam::117021046850:role/pubfeed_unauth_MOBILEHUB_827307080"
        let authRoleArn = "arn:awsiam::117021046850:role/Cognito_PubFeedAuth_Role"
     
        
        
//        let credentialsProvider = AWSCognitoCredentialsProvider.credentialsWithRegionType(
//            AWSRegionType.USEast1,
//            accountId: cognitoAccountId,
//            identityPoolId: cognitoIdentityPoolId,
//            unauthRoleArn: cognitoUnauthRoleArn,
//            authRoleArn: cognitoAuthRoleArn)
//        let defaultServiceConfiguration = AWSServiceConfiguration(
//            region: AWSRegionType.USEast1,
//            credentialsProvider: credentialsProvider)
//        AWSServiceManager.defaultServiceManager().setDefaultServiceConfiguration(defaultServiceConfiguration)


        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: identityPoolId)
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

