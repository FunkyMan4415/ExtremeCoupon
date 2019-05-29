//
//  ScanView.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 29.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

@IBDesignable
class ScanView: UIView {
    
    @IBInspectable
    var layerOne: Bool = false {
        didSet {
            let l1 = CALayer()
            l1.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
            l1.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY - 5, width: 50, height: 5)
            
            let l2 = CALayer()
            l2.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
            l2.frame = CGRect(x: self.bounds.minX - 5, y: self.bounds.minY - 5, width: 5, height: 50)
            
            
            self.layer.addSublayer(l1)
            self.layer.addSublayer(l2)
        }
    }
    
    
    @IBInspectable
    var layerTwo: Bool = false {
        didSet {
            
            let l1 = CALayer()
            l1.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
            l1.frame = CGRect(x: self.bounds.maxX - 50, y: self.bounds.minY - 5, width: 50, height: 5)
            
            let l2 = CALayer()
            l2.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
            l2.frame = CGRect(x: self.bounds.maxX, y: self.bounds.minY - 5, width: 5, height: 50)
            self.layer.addSublayer(l1)
            self.layer.addSublayer(l2)
        }
    }
    
    @IBInspectable
    var layerThree: Bool = false {
        didSet {
            
            let l1 = CALayer()
            l1.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
            l1.frame = CGRect(x: self.bounds.maxX - 50, y: self.bounds.maxY, width: 50, height: 5)
            
            let l2 = CALayer()
            l2.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
            l2.frame = CGRect(x: self.bounds.maxX, y: self.bounds.maxY - 45, width: 5, height: 50)
            self.layer.addSublayer(l1)
            self.layer.addSublayer(l2)
        }
    }
    
    @IBInspectable
    var layerFour: Bool = false {
        didSet {
            
            let l1 = CALayer()
            l1.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
            l1.frame = CGRect(x: self.bounds.minX, y: self.bounds.maxY, width: 50, height: 5)
            
            let l2 = CALayer()
            l2.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
            l2.frame = CGRect(x: self.bounds.minX - 5, y: self.bounds.maxY - 45, width: 5, height: 50)
            
            self.layer.addSublayer(l1)
            self.layer.addSublayer(l2)
        }
    }
}
