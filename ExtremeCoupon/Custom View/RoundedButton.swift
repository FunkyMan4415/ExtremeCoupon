//
//  RoundedButton.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = CGFloat.zero {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.shadowRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    var imageToRight: Bool = false {
        didSet{
            self.b()
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

}


extension RoundedButton {
    func b() {
        self.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
    }
}
