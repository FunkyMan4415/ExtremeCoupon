//
//  CalcDiscountViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class CalcDiscountViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var paidTextField: RoundedTextField!
    @IBOutlet weak var earnedPointsTextField: RoundedTextField!
    @IBOutlet weak var discountLabel: UILabel!
   
   let numberFormatter = NumberFormatter()
   let centPerPoint: Float = 0.01
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = .decimal
    }
    
    // MARK: - Handler
    
    
    @IBAction func calculateDiscountButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let currencyText = paidTextField.text, !currencyText.isEmpty else {
            Utility.showAlertController(for: self, with: "Achtung", and: "Bitte einen Betrag eingeben")
            return
        }
        guard let formattedCurrency = numberFormatter.number(from: currencyText) else {
            Utility.showAlertController(for: self, with:"Achtung", and: "Bitte einen gültigen Betrag eingeben")
            return
        }
        
        guard let earnedPoints = earnedPointsTextField.text, !earnedPoints.isEmpty else {
            Utility.showAlertController(for: self, with:"Achtung", and: "Bitte erhaltene Punkte eingeben")
            return
        }
        
        calculateDiscount(for: formattedCurrency, and: Int(earnedPoints)!)
    }
    
    func calculateDiscount(for value: NSNumber, and points: Int) {
        let val = Float(points) * centPerPoint
        let discount = val * 100 / value.floatValue
        
        discountLabel.text  = "\(discount) % - \(value.floatValue - val) €"
    }
    
}
