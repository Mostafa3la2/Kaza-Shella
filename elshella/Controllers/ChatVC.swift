//
//  ChatVC.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/9/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var shellaTitle: UILabel!
    @IBOutlet weak var messagesTableview: UITableView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messagesTextfield: UITextField!
    
    var shella:Shella?
    var messages = [Message]()

    var user = UserServices.instance.user
    override func viewDidLoad() {
        super.viewDidLoad()
        print("wow")
//        if shella == nil && UserDefaults.standard.integer(forKey: "SelectedChannel")==0{
//            ShellaServices.instance.getFirstShella { (shella) in
//                self.shella = shella
//                self.shellaTitle.text = shella.title
//            }
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.shellaSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
            shella = Shella(title: "Select Shella", desc: "no Shella selected", imageURL: "", members: [], key: "")
        
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        messagesTableview.delegate = self
        messagesTableview.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       
        if  shella != nil && shella!.key != ""{
            ShellaServices.instance.getUserIDFor(shella: shella!) { (returnedUsers) in
                
            }
        setUpChannel()
        }
        
    }
    @objc func shellaSelected(_ notif:Notification){
        shella = UserServices.instance.selectedShella
        shellaTitle.text = shella?.title
        setUpChannel()
    }
    func setUpChannel(){
        FirebaseReferences.instance.REF_SHELLA.observe(.value) { (snapshot) in
            ShellaServices.instance.getAllMessagesFor(desiredShella: self.shella!, handler: { (returnedShellaMessages) in
                self.messages = returnedShellaMessages
                self.messagesTableview.reloadData()
                if self.messages.count > 0 {
                    self.messagesTableview.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .none, animated: true)
                }
            })
        }
    }

    @IBAction func sendBtnPressed(_ sender: Any) {
        if messagesTextfield.text != "" {
            sendBtn.isEnabled = false
            messagesTextfield.isEnabled = false
            let message = Message(content: messagesTextfield.text!, senderID: user.uid, type: .regular)
            ShellaServices.instance.uploadPost(withMessage: message, withShellaKey :(shella?.key)!) { (complete) in
                if complete{
                    self.messagesTextfield.text = ""
                    self.messagesTextfield.isEnabled = true
                    self.sendBtn.isEnabled = true
                    
                }
            }
        }
    }
    
}

extension ChatVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as? ChatCell else{return UITableViewCell()}
        let message = messages[indexPath.row]
        
        UserServices.instance.getUser(forUID: message.senderID) { (returnedUser) in
            let email = returnedUser.email
            let photoURL = returnedUser.imageURL
            if photoURL != ""{
                downloadImage(withURL: photoURL, imageView: cell.profileImg)
            }else{
                cell.profileImg.image = UIImage(named: "menuProfileIcon")
            }
            cell.configureCell(email: email, content: message.content)
            
        }
        return cell
    }
    
    
    
}
