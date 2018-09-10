//
//  LoginVC.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/9/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import Firebase
class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }


    @IBAction func loginBtnPressed(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            UserServices.instance.loginUser(withEmail: emailTextField.text!, withPassword: passwordTextField.text!) { (complete, error) in
                if complete{
                    guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") as? SWRevealViewController else {return}
                    self.present(mainVC,animated:true,completion:nil)
                    
                }else{
                    let alert = UIAlertController(title: "Login failed", message: "Login failed, make sure you entered your information correctly", preferredStyle: UIAlertControllerStyle.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert,animated: true,completion: nil)
                }
            }
        }
    }
    
    @IBAction func redirectToSignupPressed(_ sender: Any) {
        guard let signUpVC = storyboard?.instantiateViewController(withIdentifier: "signupVC") as? SignupVC else {return}
        present(signUpVC,animated:true,completion:nil)
    }
}
