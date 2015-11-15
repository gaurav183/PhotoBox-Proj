//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Gaurav Lahiry on 10/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var usernameFIeldLogin: UITextField!
    
    @IBOutlet weak var passwordFieldLogin: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameFIeldLogin.text!, password: passwordFieldLogin.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                PFUser.becomeInBackground((user?.sessionToken)!, block: { (user, error) -> Void in
                    if error != nil {
                        self.logInError("Token Invalid")
                    } else {
                        //sets current user
                    }
                })
                
                self.performSegueWithIdentifier("showPhotoBox", sender:self)
            } else {
                if let error = error {
                    let errorString = error.userInfo["error"] as? String
                    self.logInError(errorString!)
                    
                }
            }
        }
    }
    
    @IBAction func returnToStepOne(segue: UIStoryboardSegue) {
    }
    
    func logInError (error: String) {
        let notComplete = UIAlertController(title: "Log In Error",
            message: error as String,
            preferredStyle: UIAlertControllerStyle.Alert)
        notComplete.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(notComplete, animated: true, completion: nil)
    }
    
}

