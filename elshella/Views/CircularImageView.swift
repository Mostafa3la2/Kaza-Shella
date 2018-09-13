//
//  CircularImageView.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/13/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

@IBDesignable
class CircularImageView: UIImageView {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    
    func setUpView(){
        self.layer.cornerRadius = (self.frame.size.width ?? 0.0) / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
    }

}
