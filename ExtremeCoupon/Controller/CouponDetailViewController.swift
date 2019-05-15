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
    @IBOutlet weak var barcodeCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        couponCodeImageView.image = Barcode.fromString(code: coupon.code)
        couponTitleLabel.text = coupon.title
        barcodeCodeLabel.text = coupon.code
    }

    @IBAction func couponButtonTapped(_ sender: RoundedButton) {
        updateVoting(true)
    }
    
    @IBAction func couponNotWorkButtonTapped(_ sender: RoundedButton) {
        updateVoting(false)
    }
    
    
    func updateVoting(_ success: Bool) {
        if let rating = coupon.rating {
            if success {
                rating.upVote += 1
            } else {
                rating.downVote += 1
            }
            
            rating.totalVote += 1
            coupon.rating = rating
            
            FirebaseHelper.updateCoupon(coupon) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
    }

}
