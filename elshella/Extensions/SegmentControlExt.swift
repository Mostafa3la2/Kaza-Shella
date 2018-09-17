//
//  SegmentControlExt.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/15/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.gray) {
        let defaultAttributes = [
            NSAttributedStringKey.font.rawValue: font,
            NSAttributedStringKey.foregroundColor.rawValue: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red) {
        let selectedAttributes = [
            NSAttributedStringKey.font.rawValue: font,
            NSAttributedStringKey.foregroundColor.rawValue: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
