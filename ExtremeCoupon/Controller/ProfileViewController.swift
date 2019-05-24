//
//  ProfileViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 19.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error")
        }
        
        if let _ = UserDefaults.standard.object(forKey: "userId") {
            UserDefaults.standard.set(nil, forKey: "userId")
            UserDefaults.standard.set(false, forKey: "onboardingCompleted")
            dismiss(animated: true, completion: nil)
        }
    }
}
