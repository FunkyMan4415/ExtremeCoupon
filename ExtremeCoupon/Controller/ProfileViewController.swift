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

        // Do any additional setup after loading the view.
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error")
        }
        
        if let _ = UserDefaults.standard.object(forKey: "userId") {
            UserDefaults.standard.set(nil, forKey: "userId")
            dismiss(animated: true, completion: nil)
        }
    }
}
