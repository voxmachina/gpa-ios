//
//  ViewController.swift
//  GPA
//
//  Created by Pedro on 18/11/15.
//  Copyright © 2015 Pedro. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet var googleSignInButton: GIDSignInButton!
    
    @IBOutlet var debugLabel: UILabel!
    
    @IBOutlet var googleSignOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "475540245735-uij4cg5s9ea6pfbt3mkrqrr6ps9l4emn.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/calendar")
        
        // Uncomment to automatically sign in the user.
//        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        toggleAuthUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        toggleAuthUI()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let _ = error {
            print(error)
        }
        else {
            toggleAuthUI()
        }
    }
    
    
    func getCalendars() {
        
        if let googleAuthToken = GIDSignIn.sharedInstance().currentUser?.authentication.accessToken {
            let urlString = "https://www.googleapis.com/calendar/v3/users/me/calendarList?access_token=\(googleAuthToken)"
            
            print(urlString)
            
            do {
                let opt = try HTTP.GET(urlString)
                opt.start { response in
                    if let error = response.error {
                        print("got an error: \(error)")
                        return
                    }
                    let json = JSON(data: response.data)
                    if let description = json["items"][0]["description"].string {
                        self.debugLabel.text = description
                    } else {
                        print(json["items"][0]["description"].error) // "Dictionary["address"] does not exist"
                    }
                }
            } catch let error {
                print("got an error: \(error)")
            }
            
        } else {
            print("Unable to retrieve user google auth token")
        }
    }
    
    
    
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            googleSignInButton.hidden = true
            debugLabel.hidden = false
            googleSignOutButton.enabled = true
            getCalendars()
            print("LOGGED IN")
//            signOutButton.hidden = false
//            disconnectButton.hidden = false
        } else {
            print("NOT LOGGED IN")
            googleSignInButton.hidden = false
            debugLabel.hidden = true
            googleSignOutButton.enabled = false
//            signOutButton.hidden = true
//            disconnectButton.hidden = true
//            statusText.text = "Google Sign in\niOS Demo"
        }
    }


}

