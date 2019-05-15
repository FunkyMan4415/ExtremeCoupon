//
//  RoundedTextField.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedTextField: UITextField {
    
    // MARK: - Properties
    @IBInspectable
    var cornerRadius: CGFloat = CGFloat.zero {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.shadowRadius = self.cornerRadius
            layer.masksToBounds = false
        }
    }

    @IBInspectable
    var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            layer.shadowColor = self.shadowColor
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = Float.zero {
        didSet {
            layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = self.shadowOffset
        }
    }
    
    let leftButton = UIButton(type: .custom)
    
    @IBInspectable
    var image: UIImage? {
        didSet {
            leftViewMode = UITextField.ViewMode.always
        
            leftButton.setImage(self.image, for: .normal)
            leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            leftButton.frame = CGRect(x: CGFloat(0), y: CGFloat(5), width: CGFloat(30), height: CGFloat(30))
            self.leftView = leftButton
        }
    }
    
    // MARK: - Handler
    override func awakeFromNib() {
        self.addToolbar()
    }
    
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action.description == "paste:" || action.description == "copy:" {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension RoundedTextField {
    
    func addToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Fertig", style: .plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([doneButton, spaceButton], animated: true)
        self.inputAccessoryView = toolbar
    }
    
    @objc
    func doneButtonTapped() {
        self.endEditing(true)
    }
    
    func marktInputMode(delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource) {
        let picker = UIPickerView()
        picker.delegate = delegate
        picker.dataSource = dataSource
        self.inputView = picker
    }
}
