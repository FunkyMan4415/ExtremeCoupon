//
//  CouponDetailViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 11.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class CouponDetailViewController: UIViewController {
    @IBOutlet weak var couponCodeImageView: UIImageView!
    var coupon: Coupon!
    @IBOutlet weak var couponTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        couponCodeImageView.image = Barcode.fromString(code: coupon.code)
        couponTitleLabel.text = coupon.title
    }

    
    

}
