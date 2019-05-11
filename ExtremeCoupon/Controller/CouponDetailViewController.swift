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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponCodeImageView.image = Barcode.fromString(code: coupon.code)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
