//
//  HomeViewController.swift
//  Covid
//
//  Created by Jaafar Barek on 24/04/2021.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDate: UILabel!
    @IBOutlet weak var riskLabel: UILabel!
    
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var activeButton: UIButton!
    
    var isActive = false {
        didSet {
            setActiveState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isActiveDefault = UserDefaults.standard.value(forKey: "isActive") as? Bool {
            self.isActive = isActiveDefault
        }
        
        setActiveState()
    }
    
    func setActiveState() {
        if isActive {
            onActiveEnabled()
        } else {
            onActiveDisabled()
        }
    }
    
    func onActiveEnabled() {
        statusView.backgroundColor = UIColor(red: 191, green: 0, blue: 67)
        statusLabel.text = "Corona Virus Detected"
        statusDate.text = "Quarantine till 10/10/2022"
        riskLabel.text = "HIGH RISK"
        
        activeView.isHidden = true
    }
    
    func onActiveDisabled() {
        statusView.backgroundColor = UIColor(red: 60, green: 141, blue: 85)
        statusLabel.text = "No exposures"
        statusDate.text = "Update today at: \(Date())"
        riskLabel.text = "LOW RISK"
        activeView.isHidden = false
    }

    @IBAction func onActivateButtonTap(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "isActive")
        self.isActive = true
    }
}
