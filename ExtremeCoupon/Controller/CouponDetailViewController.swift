//
//  CouponDetailViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 11.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol CouponDetailViewDelegate {
    func didUsedCoupon(coupon: Coupon)
}

class CouponDetailViewController: UIViewController {
    @IBOutlet weak var couponCodeImageView: UIImageView!
    @IBOutlet weak var couponTitleLabel: UILabel!
    @IBOutlet weak var barcodeCodeLabel: UILabel!
    @IBOutlet weak var upVoteButton: RoundedButton!
    @IBOutlet weak var downVoteButton: RoundedButton!
    var coupon: Coupon!
    var delegate: CouponDetailViewDelegate? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        couponCodeImageView.image = Barcode.fromString(code: coupon.code)
        couponTitleLabel.text = coupon.title
        barcodeCodeLabel.text = coupon.code
        
        if UserDefaults.standard.bool(forKey: "anonymousLogin") {
            upVoteButton.isEnabled = false
            downVoteButton.isEnabled = false
        }
        
        
    }

    @IBAction func couponButtonTapped(_ sender: RoundedButton) {
        updateVoting(true)
        
        // remove coupon for user....
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            FirebaseHelper.updateCoupon(coupon, for: uid)
        }
    }
    
    @IBAction func couponNotWorkButtonTapped(_ sender: RoundedButton) {
        updateVoting(false)
        
        // remove Coupon for User.....
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            FirebaseHelper.updateCoupon(coupon, for: uid)
        }
    }
    
    
    func updateVoting(_ success: Bool) {
        delegate?.didUsedCoupon(coupon: coupon)
        if let rating = coupon.rating {
            if success {
                rating.upVote += 1
            } else {
                rating.downVote += 1
            }
            
            rating.totalVote += 1
            coupon.rating = rating
            
            FirebaseHelper.updateCoupon(coupon) { (success) in}
            self.navigationController?.popViewController(animated: true)
        }
    }

}
