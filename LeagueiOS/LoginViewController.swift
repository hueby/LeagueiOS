//
//  ViewController.swift
//  LeagueiOS
//
//  Created by Dennis on 06.06.18.
//  Copyright © 2018 Dennis Hübner. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginDidTouch(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: self.loginTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if(error == nil) {
                print("\(user!) logged in")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func registerDidTouch(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: self.loginTextField.text!, password: self.passwordTextField.text!){ (authResult, error) in
            if(error != nil) {
                print("Done \(authResult!)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

