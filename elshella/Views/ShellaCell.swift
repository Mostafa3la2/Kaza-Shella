//
//  ShellaCell.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/12/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ShellaCell: UITableViewCell {


    @IBOutlet weak var shellaImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var membersCountLbl: UILabel!
    
    func configureCell(title:String,description:String,membersCount:String){
        self.titleLbl.text = title
        self.descriptionLbl.text = description
        self.membersCountLbl.text = membersCount
    }
    func setCellImage(image:UIImage){
        self.shellaImage.image = image
    }
    
}
