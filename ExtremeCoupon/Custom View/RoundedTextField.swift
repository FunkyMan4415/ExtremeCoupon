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
    
    let rightButton = UIButton(type: .custom)
    
    @IBInspectable
    var image: UIImage? {
        didSet {
            rightViewMode = UITextField.ViewMode.always
        
            rightButton.setImage(self.image, for: .normal)
            rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            rightButton.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(30))
            self.rightView = rightButton
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
}
