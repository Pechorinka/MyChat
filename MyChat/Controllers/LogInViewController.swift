//
//  LoginViewController.swift
//  MyChat
//
//  Created by Tatyana Sidoryuk on 13.08.2022.
//


import Firebase
import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
        
        Auth.auth().signIn(withEmail: email, password: password) { authresult, error in
                if let e = error {
                    print (e)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
}
