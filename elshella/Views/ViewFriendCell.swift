//
//  ViewFriendCell.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/15/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ViewFriendCell: UITableViewCell {


    @IBOutlet weak var friendEmail: UILabel!
    @IBOutlet weak var profileImg: CircularImageView!
    
    var uid:String = ""

    func configureCell(email:String){
        self.friendEmail.text = email
        
    }
    
}
