//
//  UserCell.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/10/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var checkmarkImg: UIImageView!
    
    var showToggle = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected{
            if !showToggle{
                checkmarkImg.isHidden = false
                showToggle = true
            }else{
                checkmarkImg.isHidden = true
                showToggle = false
            }
        }
    }
    func configureCell(username:String,isSelected:Bool){
        self.usernameLbl.text = username
        self.checkmarkImg.isHidden = !isSelected
    }

}
