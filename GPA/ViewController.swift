//
//  ViewController.swift
//  GPA
//
//  Created by Pedro on 18/11/15.
//  Copyright © 2015 Pedro. All rights reserved.
//

import UIKit
import SwiftHTTP

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    struct Response: JSONJoy {
        let status: String?
        init(_ decoder: JSONDecoder) {
            status = decoder["status"].string
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "475540245735-uij4cg5s9ea6pfbt3mkrqrr6ps9l4emn.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/calendar")
        
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        toggleAuthUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let _ = error {
            print(error)
        }
        else {
            toggleAuthUI()
        }
    }
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    
    
    func getCalendars() {
        
        if let googleAuthToken = GIDSignIn.sharedInstance().currentUser?.authentication.accessToken {
            let urlString = "https://www.googleapis.com/calendar/v3/users/me/calendarList?access_token=\(googleAuthToken)"
            
            do {
                let opt = try HTTP.GET(urlString)
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    print("opt finished: \(response.description)")
                    print("data is: \(response.data)") //  access the response of the data with response.data
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
            
        } else {
            print("Unable to retrieve user google auth token")
        }
    }
    
    
    
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            googleSignInButton.hidden = true
            getCalendars()
            print("LOGGED IN")
//            signOutButton.hidden = false
//            disconnectButton.hidden = false
        } else {
            print("NOT LOGGED IN")
            googleSignInButton.hidden = false
//            signOutButton.hidden = true
//            disconnectButton.hidden = true
//            statusText.text = "Google Sign in\niOS Demo"
        }
    }


}

