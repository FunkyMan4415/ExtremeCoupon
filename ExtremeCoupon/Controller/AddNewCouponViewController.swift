//
//  AddNewCouponViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class AddNewCouponViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var couponCodeTextField: RoundedTextField!
    @IBOutlet weak var couponTitleTextField: RoundedTextField!
    @IBOutlet weak var couponDateTextField: RoundedTextField!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponCodeTextField.rightButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)

    }
    
    
    // MARK: - Handler
    @IBAction func insertNewCouponButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @objc
    func cameraButtonTapped() {
        let alertController = UIAlertController(title: "Oh Nein :-(", message: "Die Kamerafunktion ist leider noch nicht entwickelt.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Schade", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }


}
