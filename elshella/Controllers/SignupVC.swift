//
//  SignupVC.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/9/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func signupBtnPressed(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            
            UserServices.instance.createUser(WithEmail: emailTextField.text!, andPassword: passwordTextField.text!) { (complete, error) in
                if complete{
                    UserServices.instance.loginUser(withEmail: self.emailTextField.text!, withPassword: self.passwordTextField.text!, loginComplete: { (success, error) in
                        if success{
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
                else{
                let alert = UIAlertController(title: "Sign up failed", message: "Sign up failed, make sure you entered your information correctly", preferredStyle: UIAlertControllerStyle.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert,animated: true,completion: nil)
                }
            }
        }
    }
    
}
