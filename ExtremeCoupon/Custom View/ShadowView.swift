//
//  ShadowView.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = CGFloat.zero {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.shadowRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            layer.shadowColor = self.shadowColor
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = self.shadowOffset
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = Float.zero {
        didSet {
            layer.shadowOpacity = self.shadowOpacity
        }
    }
}
