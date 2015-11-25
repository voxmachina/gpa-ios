//
//  AddAccountViewController.swift
//  GPA
//
//  Created by Pedro on 24/11/15.
//  Copyright © 2015 Pedro. All rights reserved.
//

import UIKit

import AeroGearHttp
import AeroGearOAuth2

class AddAccountViewController: UIViewController {
    
    var http: Http!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Let's register for settings update notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleSettingsChangedNotification",
            name: NSUserDefaultsDidChangeNotification, object: nil)
        self.http = Http()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleSettingsChangedNotification() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let clear = userDefaults.boolForKey("clearShootKeychain")
        
        if clear {
            print("clearing keychain")
            let kc = KeychainWrap()
            kc.resetKeychain()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectToGoogle(sender: AnyObject) {
        print("Perform connect with Google")
        
        let googleConfig = GoogleConfig(
            clientId: "475540245735-uij4cg5s9ea6pfbt3mkrqrr6ps9l4emn.apps.googleusercontent.com",
            scopes:["https://www.googleapis.com/auth/calendar"],
            accountId: "dummy")
        // If you want to use embedded web view uncomment
        googleConfig.isWebView = true
        
        // Workaround issue on Keychain https://forums.developer.apple.com/message/23323
        let gdModule =  OAuth2Module(config: googleConfig)
        
        //let gdModule = AccountManager.addGoogleAccount(googleConfig)
        self.http.authzModule = gdModule
        
        gdModule.requestAccess { (response:AnyObject?, error:NSError?) -> Void in
            if (error != nil) {
                self.presentAlert("Error", message: error!.localizedDescription)
            } else {
                self.performAuthRequest("https://www.googleapis.com/calendar/v3/users/me/calendarList", parameters: nil)
            }
        }
        
    }
    
    func performAuthRequest(url: String, parameters: [String: AnyObject]?) {
//        self.http.POST(url, parameters: parameters, completionHandler: {(response, error) in
//            if (error != nil) {
//                self.presentAlert("Error", message: error!.localizedDescription)
//            } else {
//                self.presentAlert("Success", message: "Successfully uploaded!")
//            }
//        })
        self.http.GET(url, completionHandler: {(response, error) in
            if (error != nil) {
                self.presentAlert("Error", message: error!.localizedDescription)
            } else {
                print(response)
                self.presentAlert("Success", message: "Google account added!")
            }
        })
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
