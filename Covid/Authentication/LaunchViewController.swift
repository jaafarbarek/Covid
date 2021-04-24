//
//  LaunchViewController.swift
//  Jini
//
//  Created by Jaafar Barek on 4/7/18.
//  Copyright © 2018 Jaafar Barek. All rights reserved.
//

import UIKit
import Lottie
class LaunchViewController: UIViewController {

    @IBOutlet private weak var animationContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setUpAnimation(withName: "17977-corona-virus")
    }
    
}
// MARK: - Private helper methods
private extension LaunchViewController {
    func setUpAnimation(withName name: String) {
        let animationFileName = name

        let animationView = AnimationView(name: animationFileName)
        animationView.frame = animationContainerView.bounds
        animationContainerView.addSubview(animationView)
        animationView.play { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self?.navigateToOnboardingViewController()
            }
        }
    }

    func navigateToOnboardingViewController() {
//        Constants.transitionToLoginScreen()
        Constants.transitionToMainScreen()
    }
}
