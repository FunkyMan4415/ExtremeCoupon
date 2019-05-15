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
    @IBOutlet weak var couponDateUntilTextField: RoundedTextField!
    @IBOutlet weak var marktTextField: RoundedTextField!
    
    var market = [Market]()
    var couponDate: Date?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        market.removeAll()
        FirebaseHelper.getAllMarkets { (markets) in
            self.market = markets
        }
        
        dateInputMode()
        couponCodeTextField.leftButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        marktTextField.marktInputMode(delegate: self, dataSource: self)
        
        // append add Button to toolbar
        appendAddNewMarktBarButton()
    }
    
    
    // MARK: - Handler
    func dateInputMode() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(addDateText), for: .valueChanged)
        
        couponDateUntilTextField.inputView = datePicker
    }
    
    @objc
    func addDateText(_ datePicker: UIDatePicker){
        couponDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        couponDateUntilTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    @IBAction func insertNewCouponButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let couponTitleText = couponTitleTextField.text, !couponTitleText.isEmpty else {return}
        guard let couponDateText = couponDateUntilTextField.text, !couponDateText.isEmpty else {return}
        guard let couponCodeText = couponCodeTextField.text, !couponCodeText.isEmpty else {return}
        guard let couponMarketText = marktTextField.text, !couponMarketText.isEmpty else {return}
        
        let currentDay = Calendar.current.startOfDay(for: couponDate!)
        
        let coupon = Coupon(uuid: NSUUID().uuidString, title: couponTitleText, date: currentDay, code: couponCodeText, rating: Rating(), market: couponMarketText)
        
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
        couponDateUntilTextField.text = ""
        marktTextField.text = ""
    }
    
    @objc
    func addMarktButton() {
        let addNewMarketVC = AddNewMarketViewController()
        addNewMarketVC.delegate = self
        self.view.endEditing(true)
        navigationController?.pushViewController(addNewMarketVC, animated: true)
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
        return market.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return market[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        marktTextField.text = market[row].title
    }
    
}

extension AddNewCouponViewController : AddNewMarketDelegate {
    func didUpdateNewMarket(_ market: Market) {
        FirebaseHelper.getAllMarkets { (markets) in
            self.market.removeAll()
            self.market = markets
            
        }
    }
    
    
    
}
