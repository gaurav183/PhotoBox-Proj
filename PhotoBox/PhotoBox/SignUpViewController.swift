//
//  SignUpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Gaurav Lahiry on 10/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func signup(sender: AnyObject) {
        if (usernameField.text == "" || passwordField.text == "" || emailField.text == "") {
            self.signUpError("Please make sure all fields are complete")
            
        } else {
            let user = PFUser()
            user.username = usernameField.text
            user.password = passwordField.text
            user.email = emailField.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? String
                    self.signUpError(errorString!)
                    
                } else {
                    self.performSegueWithIdentifier("showLoginViewController", sender:self)
                }
            }
        }
    }
    
    func signUpError (error: String) {
        let notComplete = UIAlertController(title: "Sign Up Error",
                                          message: error as String,
                                   preferredStyle: UIAlertControllerStyle.Alert)
        notComplete.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(notComplete, animated: true, completion: nil)
    }
}
    
