//
//  ViewRequestCell.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/15/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ViewRequestCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircularImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var acceptRequestBtn: UIButton!




    func configureCell(email:String){
        self.emailLbl.text = email
        
    }
}
