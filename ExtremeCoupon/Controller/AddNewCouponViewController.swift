//
//  AddNewCouponViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import AVFoundation

protocol AddNewCouponDelegate {
    func didAddNewCoupon(for coupon: Coupon)
}

class AddNewCouponViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var couponCodeTextField: RoundedTextField!
    @IBOutlet weak var couponTitleTextField: RoundedTextField!
    @IBOutlet weak var couponDateTextField: RoundedTextField!
    
    var delegate: AddNewCouponDelegate?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponDateTextField.dateInputMode()
        couponCodeTextField.rightButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)

    }
    
    
    // MARK: - Handler
    @IBAction func insertNewCouponButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let couponTitleText = couponTitleTextField.text, !couponTitleText.isEmpty else {return}
        guard let couponDateText = couponDateTextField.text, !couponDateText.isEmpty else {return}
        guard let couponCodeText = couponCodeTextField.text, !couponCodeText.isEmpty else {return}
        
        let coupon = Coupon(title: couponTitleText, date: couponDateText, code: couponCodeText, rating: nil)
        delegate?.didAddNewCoupon(for: coupon)
        
        Utility.showAlertController(for: self, with: "Erfolg", and: "Coupon erfolgreich angelegt")
        clearAllFields()
    }
    
    func clearAllFields() {
        couponCodeTextField.text = ""
        couponTitleTextField.text = ""
        couponDateTextField.text = ""
    }
    
    @objc
    func cameraButtonTapped() {
        guard let _ = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else {
            Utility.showAlertController(for: self, with: "Oh nein", and: "Dein Gerät unterstützt die Kamerafunktion leider nicht :-(")
            return
        }
        
        let barcodeViewController = BarcodeViewController()
        barcodeViewController.delegate = self
        
        present(barcodeViewController, animated: true, completion: nil)
    }


}


// MARK: - Extension
extension AddNewCouponViewController: BarcodeScannerDelegate {
    func didDetectedBarcode(for code: String?) {
        if let scannedCode = code {
            couponCodeTextField.text = scannedCode
        }
        
    }
    
    
}
