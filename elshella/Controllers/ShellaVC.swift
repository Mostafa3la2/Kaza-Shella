//
//  ViewController.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/9/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import Firebase
class ShellaVC: UIViewController {

    @IBOutlet weak var shellaTableView: UITableView!
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var shellaArray = [Shella]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ShellaVC.leftChannel(_:)), name: NOTIF_CHANNEL_LEFT, object: nil)
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 40
        shellaTableView.delegate = self
        shellaTableView.dataSource = self
        emailLbl.text = UserServices.instance.user.email!
        UserServices.instance.getFriends { (success) in
            if success{
                print("friends fetched successfully")
            }
        }
        UserServices.instance.getRequests { (success) in
            if success{
                print("requests fetched successfully")
            }
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseReferences.instance.REF_SHELLA.observe(.value) { (snapShot) in
            ShellaServices.instance.getAllShellas(handler: { (success) in
                if success{
                    self.shellaArray = UserServices.instance.shellas
                    print(self.shellaArray.count)
                    self.shellaTableView.reloadData()
                }
            })
        }
        UserServices.instance.getImageURL(forUserId: UserServices.instance.user.uid) { (returnedImageURL) in
            let imageURL = returnedImageURL
            if imageURL != ""{
                downloadImage(withURL: imageURL, imageView: self.profileImage)}
        }

        
    }
    @objc func leftChannel(_ notif:Notification){
        shellaArray = UserServices.instance.shellas
        shellaTableView.reloadData()
    }

}
extension ShellaVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shellaArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shellaCell") as? ShellaCell else {return UITableViewCell()}
        let shella = shellaArray[indexPath.row]
        let image = UIImage(named: "menuProfileIcon")
        if shella.imageURL != ""{
            downloadImage(withURL: shella.imageURL,imageView: cell.shellaImage)
        }else{
            cell.setCellImage(image: image!)
        }
        cell.configureCell( title: shella.title, description: shella.desc, membersCount: String(shella.membersCount))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //let chatVC = self.revealViewController().frontViewController as! ChatVC
        //chatVC.initShellaData(forShella: shellaArray[indexPath.row])
        //how to update chatVC ??
        UserServices.instance.selectedShella = shellaArray[indexPath.row]
        let index = IndexPath(row:indexPath.row,section:0)
        shellaTableView.reloadRows(at: [index], with: .none)
        shellaTableView.selectRow(at: index, animated: false, scrollPosition: .none)
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
        
    }

    
    
}
