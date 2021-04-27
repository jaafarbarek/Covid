//
//  CustomDesignTextField.swift
//  Covid
//
//  Created by Jaafar Barek on 27/04/2021.
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
