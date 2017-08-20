//
//  SignInViewController.swift
//  SnapClone
//
//  Created by Matthew Bourke on 20/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit
import Firebase // For using FireBase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func turnUpTapped(_ sender: Any) {
        // Function for FireBase signin
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
            print("We tried to sign in")
            
            // If an error occurs when trying to sign in, run function to create user instead
            if error != nil {
                print("ERROR: \(String(describing: error))")
                
                // Function to create user in FireBase
                Auth.auth().createUser(withEmail: self.emailTF.text!, password: self.passwordTF.text!, completion: { (user, error) in
                    print("Trying to create new user")
                    // If there is an error, print the error.
                    if error != nil {
                        print("ERROR: \(String(describing: error))")
                    // Otherwise, print confirmation message and segue to next VC
                    } else {
                        print("Created new user!")
                        self.performSegue(withIdentifier: "signinSegue", sender: nil)
                    }
                })
            // If signin is successful, print confirmation message, and segue to next VC
            } else {
                
                print("Sign in successful")
                
                self.performSegue(withIdentifier: "signinSegue", sender: nil)
            }
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

