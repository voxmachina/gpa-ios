//
//  AppDelegate.swift
//  GPA
//
//  Created by Pedro on 18/11/15.
//  Copyright © 2015 Pedro. All rights reserved.
//

import UIKit
import AeroGearOAuth2

let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.tintColor = themeColor
        prepareDefaultSettings()
        return true
    }
    
    private func prepareDefaultSettings() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let clear = userDefaults.boolForKey("clearShootKeychain")
        let kcDebug = KeychainWrap()
        print(kcDebug.read("dummy", tokenType: TokenType.AccessToken))
        
//        print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        
        if (clear) {
            print("clearing Keychain")
            let kc = KeychainWrap()
            kc.resetKeychain()
        }
        // default values
        userDefaults.registerDefaults(["key_url" : ""])
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
            let notification = NSNotification(name: AGAppLaunchedWithURLNotification, object:nil, userInfo:[UIApplicationLaunchOptionsURLKey:url])
            NSNotificationCenter.defaultCenter().postNotification(notification)
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
        NSNotificationCenter.defaultCenter().postNotificationName(AGAppDidBecomeActiveNotification, object:nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

