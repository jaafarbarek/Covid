//
//  CustomDesignTextField.swift
//  Lille
//
//  Created by Apple on 1/17/17.
//  Copyright © 2017 iflat-apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CustomDesignTextField: SkyFloatingLabelTextField {

    override func awakeFromNib() {

        self.selectedLineColor = Constants.lightGrayColor

        self.textAlignment = .left
        self.lineColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1)
        self.titleColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        self.placeholderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        self.tintColor = UIColor.darkGray
        self.selectedTitleColor = UIColor.lightGray
        self.placeholderFont = UIFont(name: "Poppins-Regular", size: 14)
        self.selectedLineColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1)
        
        
    }
}
