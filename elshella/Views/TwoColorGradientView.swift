//
//  TwoColorGradientView.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/9/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit


@IBDesignable
class TwoColorGradientView: UIView {

    @IBInspectable var topColor:UIColor = #colorLiteral(red: 0.5, green: 0.2019886067, blue: 0.415384049, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    @IBInspectable var bottomColor:UIColor = #colorLiteral(red: 0.5, green: 0.2019886067, blue: 0.415384049, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
