//
//  LoginViewController.swift
//  Jini
//
//  Created by Jaafar Barek on 4/8/18.
//  Copyright © 2018 Jaafar Barek. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var emailAddressTextField: CustomDesignTextField!
    @IBOutlet weak var passwordTextField: CustomDesignTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var textFields: [CustomDesignTextField]!
    
    var activityIndicatorView:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        activityIndicatorView =  NVActivityIndicatorView(frame: btnFrame, type: .ballClipRotateMultiple, color: Constants.blueColor)
        hideKeyboardWhenTappedAround()
        
        for i in textFields {
            i.delegate = self
        }
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
    }
    
    private func showSpinning() {
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.addSubview(activityIndicatorView)
        centerActivityIndicatorInButton()
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        loginButton.setTitle("", for: .normal)
    }
    private func hideSpinning() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        loginButton.setTitle("Login", for: .normal)
    }
    private func centerActivityIndicatorInButton() {
       activityIndicatorView.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let currentIndex = textFields.index(of: textField as! CustomDesignTextField), currentIndex < textFields.count-1 {
            textFields[currentIndex+1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func onRegisterTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Registration", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterWithMailViewController")
        present(vc, animated: true, completion: nil)
    }
    @IBAction func onLoginTapped(_ sender: UIButton) {
        if emailAddressTextField.text!.isEmpty {
            shakeView(anyView: emailAddressTextField)
        }
        if passwordTextField.text!.isEmpty {
            shakeView(anyView: passwordTextField)
        }
        if !passwordTextField.text!.isEmpty &&  !emailAddressTextField.text!.isEmpty {
            DispatchQueue.main.async(execute: {
                self.showSpinning()
            })
            
//            Constants.transitionToMainScreen()
            
            User.loginUserAPI(withEmail: self.emailAddressTextField.text!, password: self.passwordTextField.text!, completion: { (status) in
                DispatchQueue.main.async(execute: {
                    self.hideSpinning()
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
    }
}
