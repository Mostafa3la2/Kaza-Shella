//
//  ProfileVC.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/14/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import Firebase
class ProfileVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var userSearchTextField: UITextField!
    
    let user = UserServices.instance.user
    var segmentType : SegmentType = .ViewFriend
    var usersArray = [OtherUser]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let font = UIFont(name: "American Typewriter", size: 14)
        segment.defaultConfiguration(font: font!, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        segment.selectedConfiguration(font: font!, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        usersArray = UserServices.instance.friends
        
        
        emailLbl.text = user.email!
        if let photoURL = user.photoURL{
            downloadImage(withURL: photoURL.absoluteString, imageView: profileImg)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    
    @IBAction func textFieldDidChange(_ sender: Any) {
        if userSearchTextField.text == ""{
            //this should repopulate usersArray to initial not clear 
            switch segmentType{
            case .ViewFriend:
                usersArray = UserServices.instance.friends
            case .AddFriend:
                usersArray = []
            case .ViewRequest:
                usersArray = UserServices.instance.reqeuests
            }
            tableView.reloadData()
        }else{
            switch segmentType{
            case .ViewFriend :
                UserServices.instance.getFriendsStarting(WithCharacters: userSearchTextField.text!) { (returnedFriends) in
                    self.usersArray = returnedFriends
                    self.tableView.reloadData()
                }
            case .AddFriend:
                UserServices.instance.getUsersStarting(WithCharacters: userSearchTextField.text!) { (returnedUsers) in
                    self.usersArray = returnedUsers
                    self.tableView.reloadData()
                }
            case .ViewRequest:
                print("non existent case")
            }
        }
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        
        userSearchTextField.text = ""
        switch segment.selectedSegmentIndex {
        case 0:
            segmentType = .ViewFriend
            userSearchTextField.isHidden = false
            self.usersArray = UserServices.instance.friends
            self.tableView.reloadData()
            
        case 1:
            segmentType = .AddFriend
            userSearchTextField.isHidden = false
            usersArray = []
            tableView.reloadData()
        case 2:
            segmentType = .ViewRequest
            userSearchTextField.isHidden = true
            self.usersArray = UserServices.instance.reqeuests
            self.tableView.reloadData()
            
        default:
            segmentType = .ViewFriend
            userSearchTextField.isHidden = false
            self.usersArray = UserServices.instance.friends
            self.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    @IBAction func changePicturePressed(_ sender: Any) {
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
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do{
                try Auth.auth().signOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as? LoginVC
                self.present(loginVC!,animated:true,completion:nil)
            }catch{
                print(error.localizedDescription)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup,animated: true,completion: nil)
    }

}
extension ProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] {
            profileImg.image = editedImage as? UIImage
        }else{
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            profileImg.image = image
        }
        UserServices.instance.addImage(image: profileImg.image!) { (success) in
            if success{
                imageCache.removeObject(forKey: UserServices.instance.user.photoURL?.absoluteString as AnyObject)
                self.dismiss(animated: true, completion: nil)
            }else{
                print("why?")
            }
        }
    }
    
}
extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = usersArray[indexPath.row]
        let defaultImg = UIImage(named:"menuProfileIcon")
        switch segmentType{
        case .ViewFriend :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: segmentType.rawValue) as? ViewFriendCell else{return UITableViewCell()}
            
            if user.imageURL != ""{
                downloadImage(withURL: user.imageURL, imageView: cell.profileImg)}
            else{
                cell.profileImg.image = defaultImg
            }
            cell.configureCell(email: user.email)
            return cell
        case .AddFriend :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: segmentType.rawValue) as? AddFriendCell else{return UITableViewCell()}
            if user.imageURL != ""{
                downloadImage(withURL: user.imageURL, imageView: cell.profileImg)}
            else{
                cell.profileImg.image = defaultImg
            }
           
            cell.configureCell(email: user.email)
            return cell
        case .ViewRequest:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: segmentType.rawValue) as? ViewRequestCell else{return UITableViewCell()}
            
            if user.imageURL != ""{
                downloadImage(withURL: user.imageURL, imageView: cell.profileImg)}
            else{
                cell.profileImg.image = defaultImg
            }
            cell.configureCell(email: user.email)
            
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        switch segmentType{
        case .ViewFriend:
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (rowAction, indexPath) in
                UserServices.instance.deleteFriend(withUID: self.usersArray[indexPath.row].uid, completionHandler: { (success) in
                    if success{
                        UserServices.instance.friends = UserServices.instance.friends.filter{$0.uid != self.usersArray[indexPath.row].uid}
                        print(UserServices.instance.friends)
                        self.usersArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)}
                    
                })
            }
            
            deleteAction.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.4980392157, blue: 0.1764705882, alpha: 1)
            return [deleteAction]
        case .AddFriend:
            let addAction = UITableViewRowAction(style: .normal, title: "Add") { (rowAction, indexPath) in
                UserServices.instance.sendRequest(toUID: self.usersArray[indexPath.row].uid, completionHandler: { (success) in
                    if success{
                        self.usersArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                })
            }
            addAction.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.6078431373, blue: 0.5411764706, alpha: 1)
            return [addAction]
        case .ViewRequest:
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (rowAction, indexPath) in
                UserServices.instance.deleteRequest(withUID: self.usersArray[indexPath.row].uid, completionHandler: { (success) in
                    if success{
                        UserServices.instance.reqeuests = UserServices.instance.reqeuests.filter{$0.uid != self.usersArray[indexPath.row].uid}
                        self.usersArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                })
            }
            
            deleteAction.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.4980392157, blue: 0.1764705882, alpha: 1)
            let addAction = UITableViewRowAction(style: .normal, title: "Accept") { (rowAction, indexPath) in
                UserServices.instance.acceptRequest(withUID: self.usersArray[indexPath.row].uid, completionHandler: { (success) in
                    if success{
                        UserServices.instance.reqeuests = UserServices.instance.reqeuests.filter{$0.uid != self.usersArray[indexPath.row].uid}
                        UserServices.instance.friends.append(self.usersArray[indexPath.row])
                        self.usersArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                })
            }
            addAction.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.6078431373, blue: 0.5411764706, alpha: 1)
            return [deleteAction,addAction]
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
}
