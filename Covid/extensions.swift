//
//  extensions.swift
//  style
//
//  Created by Apple on 1/12/17.
//  Copyright © 2017 YouCode. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension Notification.Name {
    static let leftMenuWillShow = Notification.Name(
        rawValue: "leftMenuWillShow")
    static let pushVC = Notification.Name(
        rawValue: "pushVC")

}


extension UIViewController{
    func dismiss(){
        if !self.isBeingDismissed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
   
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func shakeView(anyView:AnyObject){
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: anyView.center.x - 10, y: anyView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: anyView.center.x + 10, y: anyView.center.y))
        anyView.layer.add(animation, forKey: "position")
    }
    
    func setupNavigationBarCustom(){
        
        self.navigationController?.navigationBar.isTranslucent=false
        self.navigationController?.navigationBar.barTintColor=Constants.blueColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.shadowColor=Constants.blueColor.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset=CGSize(width: 0, height: 1)
        self.navigationController?.navigationBar.layer.shadowOpacity=0.1
    }
    
    func addShadowToNavigationBar(){
        
//        
//        
//        let shadowView = UIView(frame: self.navigationController!.navigationBar.frame)
//        shadowView.backgroundColor = UIColor.white
//        shadowView.layer.masksToBounds = false
//        shadowView.layer.shadowColor = UIColor(netHex:0xECECEC).cgColor
//        shadowView.layer.shadowOpacity = 0.4
//        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        shadowView.layer.shadowRadius = 1
//        view.addSubview(shadowView)

        
    }
    func createLogoInMiddleOfNavBar(){
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "logo-middle")
        imageView.tintedImage = Constants.blueColor
        imageView.contentMode = .scaleAspectFill
        navigationItem.titleView = imageView
        
    }
}

extension UIView{
    func addShadow(shadowColor: CGColor = UIColor.lightGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1, height: 2.0),
                   shadowOpacity: Float = 0.6,
                   shadowRadius: CGFloat = 0.6) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    
}
extension UILabel{
    func appendWithImage (text:String,imageName:String){
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        let myString1 = NSMutableAttributedString(string: "\(text)  ")
        myString.append(myString1)
        myString.append(attachmentStr)
        
        self.attributedText = myString
    }
    
}

extension UIImageView {
    func makeShapeCircle(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
    }
    
}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    
    func offsetFrom(date: Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0) minutes"
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return "\(minutes)"
    }
    
}
extension UIImageView {
    @IBInspectable
    var tintedImage: UIColor {
        get {
            return self.tintColor
        }
        set {
            if let img = self.image {
                let tinted = img.withRenderingMode(.alwaysTemplate)
                self.image = tinted
                self.tintColor = newValue
            }
            
        }
    }
    
}
extension UIButton {
    @IBInspectable
    var tintedImage: UIColor {
        get {
            return self.tintColor
        }
        set {
            if let origImage = self.currentImage {
                let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
                self.setImage(tintedImage, for: .normal)
                self.tintColor = newValue
            }
            
        }
    }
    func changeTint(color:UIColor) {
        
        if let origImage = self.currentImage {
            let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
            self.setImage(tintedImage, for: .normal)
            self.tintColor = color
        }
      
    }
 
}
