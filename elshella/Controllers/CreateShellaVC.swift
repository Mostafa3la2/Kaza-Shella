//
//  CreateShellaVC.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/10/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import Firebase
class CreateShellaVC: UIViewController {

    @IBOutlet weak var shellaTitleTextField: UITextField!
    
    @IBOutlet weak var shellaDescriptionTextField: UITextField!
    @IBOutlet weak var usersTextField: UITextField!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    var usersArray = [OtherUser]()
    var selectedUsersArray = [String]()
    var imagePicked:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTextField.delegate = self
        usersTableView.delegate = self
        usersTableView.dataSource = self
        shellaDescriptionTextField.delegate = self
        shellaTitleTextField.delegate = self
        usersTextField.addTarget(self, action: #selector(textFielddidChange), for: .editingChanged)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shellaTitleTextField.text != "" && shellaDescriptionTextField.text != "" {
            doneBtn.isHidden = false
        }else{
            doneBtn.isHidden = true}
        
        
    }
    
    @objc func textFielddidChange(){
        if usersTextField.text == ""{
            usersArray = []
            usersTableView.reloadData()
        }else{
            UserServices.instance.getFriendsStarting(WithCharacters: usersTextField.text!) { (returnedUsersArray) in
                self.usersArray = returnedUsersArray
                self.usersTableView.reloadData()
            }
        }
    }
    
    @IBAction func descriptionfieldEdited(_ sender: UITextField) {
        if shellaTitleTextField.text != "" && shellaDescriptionTextField.text != ""{
            doneBtn.isHidden = false
        }
    }
    
    @IBAction func titlefieldEdited(_ sender: UITextField) {
        if shellaDescriptionTextField.text != "" && shellaTitleTextField.text != ""{
            doneBtn.isHidden = false
        }else{
            doneBtn.isHidden = true
        }
    }
    

    @IBAction func addPicturePressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagepicker = UIImagePickerController()
            imagepicker.delegate = self
            imagepicker.sourceType = .photoLibrary
            imagepicker.allowsEditing = true
            self.present(imagepicker,animated:true,completion: nil)
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnPressed(_ sender: Any) {
        if shellaTitleTextField.text != "" && shellaDescriptionTextField.text != ""{
            var userIds = [String]()
            
            UserServices.instance.getIds(forEmails: selectedUsersArray) { (idsArray) in
                print(self.selectedUsersArray)
                userIds = idsArray
                let me = Auth.auth().currentUser?.uid
                userIds.append(me!)
                var imageURL = ""
                if self.imagePicked != nil{
                    let data = UIImageJPEGRepresentation(self.imagePicked!, 0.8)!
                    FirebaseReferences.instance.REF_STORAGE.child("\(self.shellaTitleTextField.text!).png").putData(data, metadata: nil) { (metadata, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        
                        FirebaseReferences.instance.REF_STORAGE.child("\(self.shellaTitleTextField.text!).png").downloadURL(completion: { (returnedURL, error) in
                            if error != nil{
                                return
                            }else{
                                imageURL = (returnedURL?.absoluteString)!
                                print("this is the usersid Array \(userIds)")
                                ShellaServices.instance.CreateShella(withTitle: self.shellaTitleTextField.text!, andDescription: self.shellaDescriptionTextField.text!,andImageUrl: imageURL, forUserIds: userIds) { (success) in
                                    if success{
                                        
                                        self.dismiss(animated: true, completion: nil)
                                    }else{
                                        print("Cannot create group")
                                    }
                                }
                            }
                        })
                    }
                }else{
                    ShellaServices.instance.CreateShella(withTitle: self.shellaTitleTextField.text!, andDescription: self.shellaDescriptionTextField.text!,andImageUrl: imageURL, forUserIds: userIds) { (success) in
                        if success{
                            
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            print("Cannot create group")
                        }
                    }
                }
            }
            
            
        }
    }
}

extension CreateShellaVC:UITextFieldDelegate{
    
}

extension CreateShellaVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else {return UITableViewCell()}
        
        let user = usersArray[indexPath.row]
        if selectedUsersArray.contains(user.email){
            userCell.configureCell(username: user.email, isSelected: true)
        }else{
            userCell.configureCell(username: user.email, isSelected: false)
        }
        return userCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {return}
        
        if !selectedUsersArray.contains(cell.usernameLbl.text!){
            selectedUsersArray.append(cell.usernameLbl.text!)
        }else{
            selectedUsersArray = selectedUsersArray.filter({$0 != cell.usernameLbl.text! })
            if selectedUsersArray.count < 1{
            }
        }
        
        
        
    }
}
extension CreateShellaVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] {
            imagePicked = editedImage as? UIImage
        }else{
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imagePicked = image
        }
        dismiss(animated:true, completion: nil)
    }
    
    
}

