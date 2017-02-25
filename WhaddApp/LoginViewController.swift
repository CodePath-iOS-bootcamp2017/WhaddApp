//
//  LoginViewController.swift
//  WhaddApp
//
//  Created by Satyam Jaiswal on 2/24/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passowrdTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    let alertController = UIAlertController(title: "Title", message: "message", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlertController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAlertController(){
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
//            self.emailTextField.text = ""
//            self.passowrdTextfield.text = ""
        }
        self.alertController.addAction(OKAction)
    }

    @IBAction func onSignupTapped(_ sender: Any) {
        let user = PFUser()
        
        if self.validateFields() {
            user.username = self.emailTextField.text
            user.password = self.passowrdTextfield.text
            user.signUpInBackground(block: {(succeeded: Bool, error: Error?) -> Void in
                if let error = error{
                    print(error.localizedDescription)
                    self.alertController.title = "Error"
                    self.alertController.message = error.localizedDescription
                    self.present(self.alertController, animated: true, completion: nil)
                }else{
                    print("Signup successful")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            })
        }
    }
    
    @IBAction func onLoginTapped(_ sender: Any) {
        
        if self.validateFields() {
            let username = self.emailTextField.text
            let password = self.passowrdTextfield.text
        
            PFUser.logInWithUsername(inBackground: username!, password: password!, block: { (user: PFUser?, error: Error?) in
                if let error = error{
                    self.alertController.title = "Login Error"
                    self.alertController.message = error.localizedDescription
                    self.present(self.alertController, animated: true, completion: {
                        
                    })
                }else{
                    print("login successful")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            })
        }
    }
    
    func validateFields() -> Bool{
        if self.emailTextField.text!.isEmpty {
            self.alertController.message = "Username is required"
            self.present(self.alertController, animated: true, completion: nil)
            return false
        } else if self.passowrdTextfield.text!.isEmpty{
            self.alertController.message = "Password is required"
            self.present(self.alertController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
