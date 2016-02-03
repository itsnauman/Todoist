//
//  LoginViewController.swift
//  Todoist
//
//  Created by Nauman Ahmad on 2/2/16.
//  Copyright © 2016 Nauman Ahmad. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Firebase(url: "https://todonauman.firebaseio.com")
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func registerButton(sender: AnyObject) {
        self.ref.createUser(self.emailField.text!, password: self.passwordField.text!) { (err: NSError!) -> Void in
            
            if err == nil {
                self.ref.authUser(self.emailField.text!, password: self.passwordField.text!, withCompletionBlock: { (err, auth) -> Void in
                    if err == nil {
                        self.performSegueWithIdentifier("loggedIn", sender: nil)
                    }
                })
            }
            
            if err.code == -9 {
                self.errorAlert("Email In Use", message: "Use or different email or try to Login")
            }
        }
        self.passwordField.resignFirstResponder()
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        self.ref.authUser(emailField.text!, password: passwordField.text!) { (err, data) -> Void in
            
            if err != nil {
                if err.code == -6 {
                    self.errorAlert("Invalid Password", message: "Please Try Again")
                    self.passwordField.text! = ""
                }
                
                if err.code == -8 {
                    self.errorAlert("Invalid User", message: "Register An Account First")
                }
            }
            
            self.performSegueWithIdentifier("loggedIn", sender: nil)
        }
    }

    func errorAlert(title: String, message: String) {
        let passwordErrorAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let confirmAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        passwordErrorAlert.addAction(confirmAction)
        self.presentViewController(passwordErrorAlert, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
}
