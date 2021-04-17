//
//  RegisterWithMailViewController.swift
//  Jini
//
//  Created by Jaafar Barek on 4/8/18.
//  Copyright © 2018 Jaafar Barek. All rights reserved.
//

import UIKit
import CountryPicker

class RegisterWithMailViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate ,CountryPickerDelegate {
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        phoneButton.setTitle("(\(phoneCode))", for: .normal)
        picker.isHidden = true
    }
    
    @IBOutlet weak var nameTextField: CustomDesignTextField!
    @IBOutlet weak var picker: CountryPicker!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailTextField: CustomDesignTextField!
    @IBAction func onPhoneButtonPressed(_ sender: UIButton) {
        self.picker.isHidden = !self.picker.isHidden
    }
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet var correctImages: [UIImageView]!
    @IBOutlet weak var datePicker: CustomDesignTextField!
    @IBOutlet weak var passwordTextField: CustomDesignTextField!

    
    @IBOutlet weak var phonePicker: CustomDesignTextField!
    
    @IBAction func onNextButtonPressed(_ sender: UIButton) {
        
        if emailTextField.text!.isEmpty {
            shakeView(anyView: emailTextField)
            return
        }
        if passwordTextField.text!.isEmpty {
            shakeView(anyView: passwordTextField)
            return
        }
        
        if nameTextField.text!.isEmpty {
            shakeView(anyView: nameTextField)
            return
        }
        if passwordTextField.text!.isEmpty {
            shakeView(anyView: passwordTextField)
            return
        }
        
        
        self.user = User()
        let phone = phonePicker.text ?? ""
        let trimmedString = phone.trimmingCharacters(in: .whitespaces)
        if let phone = Int(trimmedString) {
               self.user.phonenumber = phone
        }else{
            self.user.phonenumber = generateRandomDigits(8)
        }
        user.email = self.emailTextField.text!
        user.name = nameTextField.text!
        
        // call api
        
        User.RegisterUserAPI(withEmail: user.email!, password: passwordTextField.text!, name: user.name!, birthdate: "", phone: "\(user.phonenumber!)", completion: { (status) in
            DispatchQueue.main.async(execute: {
//                self.hideSpinning()
            })
            if status == .success {
                DispatchQueue.main.async(execute: {
                    Constants.transitionToMainScreen()
                })
                 
            }else{
                print("error")
            }
        })
        
    }
 
    func generateRandomDigits(_ digitNumber: Int) -> Int {
        var number = 0
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += Int(randomNumber)
        }
        return number
    }
  


    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Registration"
          phoneView.isHidden = false
        hideKeyboardWhenTappedAround()
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
        
        addShadowToNavigationBar()
        makeDatePickerWithDoneButton()
        
        datePicker.text = ""
        phonePicker.keyboardType = .numberPad
        self.correctImages[2].isHidden = true
        
        
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        let black = UIColor(netHex: 0x171717)
        let theme = CountryViewTheme(countryCodeTextColor: black, countryNameTextColor: black, rowBackgroundColor: .white, showFlagsBorder: false)        //optional for UIPickerView theme changes
        
        picker.theme = theme //optional for UIPickerView theme changes
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry(code!)
    }

    func makeDatePickerWithDoneButton() {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        let datePicker = UIDatePicker(frame: CGRect(x: 30, y: 40, width: 0, height: 0))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        inputView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        
        handleDatePicker(sender: datePicker)
        
        self.datePicker.inputView = inputView
    }
   
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        let date = sender.date
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        datePicker.text = "\(day) / \(month) / \(year) "
        self.correctImages[2].isHidden = false
    }
    
    @objc func handleDoneButton(sender: UIButton) {
        datePicker.resignFirstResponder()
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        datePicker.text = formatter.string(from: sender.date)
    }
    
    var user:User!
}

