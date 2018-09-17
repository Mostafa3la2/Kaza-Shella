//
//  AddFriendCell.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/15/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class AddFriendCell: UITableViewCell {


    @IBOutlet weak var profileImg: CircularImageView!
    
    @IBOutlet weak var addFriendLbl: UILabel!
    
   
    
    func configureCell(email:String){
        self.addFriendLbl.text = email
        
    }
}
