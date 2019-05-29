//
//  AddNewCouponViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class AddNewCouponViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var couponCodeTextField: RoundedTextField!
    @IBOutlet weak var couponTitleTextField: RoundedTextField!
    @IBOutlet weak var couponDateUntilTextField: RoundedTextField!
    @IBOutlet weak var marktTextField: RoundedTextField!
    
    var market = [Market]() {
        didSet {
            market = market.sorted { (m1, m2) -> Bool in
                m1.title.lowercased() < m2.title.lowercased()
            }
        }
    }
    var couponDate: Date?
    var cachedMarkets: [Market]?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        market.removeAll()
        if let cached = FirebaseHelper.getCachedMarkets() {
            self.market = cached
        } else {
            FirebaseHelper.getAllMarkets { (markets) in
                self.market = markets
            }
        }
        
        dateInputMode()
        couponCodeTextField.leftButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        couponCodeTextField.addTarget(self, action: #selector(checkCoupon), for: .editingDidEnd)
        couponCodeTextField.delegate = self
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
        
        let user = Auth.auth().currentUser
        
        let coupon = Coupon(uuid: NSUUID().uuidString, title: couponTitleText, date: currentDay, code: couponCodeText, rating: Rating(), market: couponMarketText, username: (user?.displayName)!, ignoreForUser: nil)
        
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
            toolbar.items?.insert(newMarktLabel, at: 0)
            
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
        
        let barcodeViewController = ScanViewController()
        barcodeViewController.delegate = self
        
        
        present(barcodeViewController, animated: true, completion: nil)
    }
    
    @objc
    func checkCoupon(_ t: UITextField) {
        if let detection = detectMarket(for: t.text!) {
            self.marktTextField.text = detection
        }
    }
    
    
    func detectMarket(for coupon: String) -> String? {
        guard let market = CouponIdentifier.checkCouponNumber(couponNumber: coupon) else {return nil}

        if market == CouponMarket.customerNumber {
            Utility.showAlertController(for: self, with: "Ups", and: "Dieser Coupon scheint eine Kundennummer zu sein. Bitte überprüfe deinen Code erneut.")
            return nil
        } else {
            return market.rawValue.capitalized
        }
    }
}


// MARK: - Extension
extension AddNewCouponViewController: ScanViewControllerDelegate {
    func didDetectedBarcode(for code: String?) {
        dismiss(animated: true, completion: nil)
        if let scannedCode = code {
            if let market = detectMarket(for: scannedCode) {
                marktTextField.text = market
            }
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

extension AddNewCouponViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var str = string.replacingOccurrences(of: "tel:", with: "")
        str = str.replacingOccurrences(of: "%20", with: "")
        str = str.replacingOccurrences(of: " ", with: "")
    
        textField.text?.append(str)
        return false
    }
}
