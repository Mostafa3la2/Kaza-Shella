//
//  CreateShellaVC.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/10/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class CreateShellaVC: UIViewController {

    @IBOutlet weak var shellaTitleTextField: UITextField!
    
    @IBOutlet weak var shellaDescriptionTextField: UITextField!
    @IBOutlet weak var usersTextField: UITextField!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    var usersArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTextField.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    @objc func textFielddidChange(){
        if usersTextField.text == ""{
            usersArray = []
            usersTableView.reloadData()
        }else{
            UserServices.instance.getEmailsStarting(WithCharacters: usersTextField.text!) { (returnedUsersArray) in
                self.usersArray = returnedUsersArray
                self.usersTableView.reloadData()
            }
        }
    }
    

    @IBAction func addPicturePressed(_ sender: Any) {
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnPressed(_ sender: Any) {
    }
    
}

extension CreateShellaVC:UITextFieldDelegate{
    
}


