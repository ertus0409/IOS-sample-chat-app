//
//  SigninVC.swift
//  Chat App For IOS 10
//
//  Created by Guner Babursah on 21/09/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import UIKit
import Firebase

class SigninVC: UIViewController {
    
    private let CONTACTS_SEGUE = "ContactsSegue"
    
    
    @IBOutlet weak var emailBtn: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var passwordBtn: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.Instance.isLoggedIn() {
            performSegue(withIdentifier: CONTACTS_SEGUE, sender: nil)
        }
    }

    @IBAction func login(_ sender: Any) {
        guard let email = emailFld.text, email != "", let password = passwordFld.text, password != "" else {
            alertTheUser(title: "Eamil and Password Are Required", message: "Please enter email and password in the required fields.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: User?, error: Error?) in
            if (error == nil) {
                self.emailFld.text = ""
                self.passwordFld.text = ""
                self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil)
            } else {
                self.alertTheUser(title: "Problem With Authentication", message: (error?.localizedDescription)!)
            }
        }
        
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let email = emailFld.text, email != "", let password = passwordFld.text, password != "" else {
            alertTheUser(title: "Eamil and Password Are Required", message: "Please enter email and password in the required fields.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            if (error == nil) {
                if user?.uid != nil {
                    //Store user
                    DBProvider.Instance.saveUser(withID: (user?.uid)!, email: email, password: password)
                    //Login the user
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user: User?, error:Error?) in
                        if (error == nil) {
                            self.emailFld.text = ""
                            self.passwordFld.text = ""
                            self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil)
                        } else {
                            self.alertTheUser(title: "Problem With Authentication", message: (error?.localizedDescription)!)
                        }
                    })
                }
            } else {
                self.emailFld.text = ""
                self.passwordFld.text = ""
                self.alertTheUser(title: "Problem With Authentication", message: (error?.localizedDescription)!)
            }
        }
    }
    
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
