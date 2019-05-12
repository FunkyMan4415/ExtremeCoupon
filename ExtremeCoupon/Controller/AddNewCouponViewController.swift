//
//  AddNewCouponViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import AVFoundation

class AddNewCouponViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var couponCodeTextField: RoundedTextField!
    @IBOutlet weak var couponTitleTextField: RoundedTextField!
    @IBOutlet weak var couponDateTextField: RoundedTextField!
    @IBOutlet weak var marktTextField: RoundedTextField!
    
    let markt = ["a","b", "c","d","e","f"]
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponDateTextField.dateInputMode()
        couponCodeTextField.leftButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        marktTextField.marktInputMode(delegate: self, dataSource: self)
        
        // append add Button to toolbar
        appendAddNewMarktBarButton()
    }
    
    
    // MARK: - Handler
    @IBAction func insertNewCouponButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let couponTitleText = couponTitleTextField.text, !couponTitleText.isEmpty else {return}
        guard let couponDateText = couponDateTextField.text, !couponDateText.isEmpty else {return}
        guard let couponCodeText = couponCodeTextField.text, !couponCodeText.isEmpty else {return}
        
        let coupon = Coupon(title: couponTitleText, date: couponDateText, code: couponCodeText, rating: nil)
        
        FirebaseHelper.isCouponAlreadyInDatabase(coupon) { (exists) in
            if exists {
                Utility.showAlertController(for: self, with: "Ups!", and: "Diesen Coupon scheint es schon zu geben")
            } else {
                FirebaseHelper.saveCoupon(coupon)
                Utility.showAlertController(for: self, with: "Erfolg", and: "Coupon erfolgreich angelegt")
                self.clearAllFields()
            }
        }
        
        
        
    }
    
    
    func appendAddNewMarktBarButton() {
        if let toolbar = marktTextField.inputAccessoryView as? UIToolbar {
            let newMarktLabel = UIBarButtonItem(title: "Neuen Markt hinzufügen", style: .done, target: self, action: #selector(addMarktButton))
            toolbar.items?.append(newMarktLabel)
        }
        
    }
    
    func clearAllFields() {
        couponCodeTextField.text = ""
        couponTitleTextField.text = ""
        couponDateTextField.text = ""
        marktTextField.text = ""
    }
    
    @objc
    func addMarktButton() {
        Utility.showAlertController(for: self, with: "Neugierig?", and: "Dann sei gespannt, was du hier bald machen kannst")
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

extension AddNewCouponViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return markt[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        marktTextField.text = markt[row]
    }
    
}
