//
//  ChatCell.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/21/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(email:String,content:String){
        self.emailLbl.text=email
        self.contentLbl.text=content
    }
    
}
