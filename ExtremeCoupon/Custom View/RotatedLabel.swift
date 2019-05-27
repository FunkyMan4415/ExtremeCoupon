//
//  RotatedLabel.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 27.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

@IBDesignable
class RotatedLabel: UILabel {

    
    @IBInspectable
    var transformation: CGFloat = CGFloat.zero {
        didSet {
            self.transform = CGAffineTransform(rotationAngle: self.transformation / 2)
        }
    }

}
