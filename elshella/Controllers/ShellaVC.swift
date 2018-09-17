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
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 40
        shellaTableView.delegate = self
        shellaTableView.dataSource = self
        emailLbl.text = UserServices.instance.user.email!
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseReferences.instance.REF_SHELLA.observe(.value) { (snapShot) in
            ShellaServices.instance.getAllShellas(handler: { (returnedShellaArray) in
                self.shellaArray = returnedShellaArray
                print(self.shellaArray.count)
                self.shellaTableView.reloadData()
            })
        }
        if let photoURL = UserServices.instance.user.photoURL {
            downloadImage(withURL: photoURL.absoluteString, imageView: profileImage)
        }
        
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
    
    
}
