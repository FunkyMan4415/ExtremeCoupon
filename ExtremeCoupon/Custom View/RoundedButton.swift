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
        }
    }

}
