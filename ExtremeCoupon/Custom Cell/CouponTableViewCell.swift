//
//  CouponTableViewCell.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol CouponTableViewCellDelegate {
    func didSelectCoupon(for cell: CouponTableViewCell)
}

class CouponTableViewCell: UITableViewCell {
    @IBOutlet weak var couponTitleLabel: UILabel!
    @IBOutlet weak var couPonDateLabel: UILabel!
    @IBOutlet weak var couponUpVote: UILabel!
    @IBOutlet weak var couponCodeImageView: UIImageView!
    @IBOutlet weak var totalVoteLabel: UILabel!
    @IBOutlet weak var couponDownVote: UILabel!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var alreadsyUsedView: ShadowView!
    
    var delegate: CouponTableViewCellDelegate?
    var coupon: Coupon?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor(named: "background")
    }
    
    func configure(for coupon: Coupon, and delegate: CouponTableViewCellDelegate) {
        marketLabel.text = coupon.market
        couponTitleLabel.text = coupon.title
        userDisplayNameLabel.text = coupon.username
        if let rating = coupon.rating, rating.totalVote > 0, (rating.upVote > 0 || rating.downVote > 0) {
            couponUpVote.text = "\(rating.upVote * 100 / rating.totalVote) %"
            couponDownVote.text = "\(rating.downVote * 100 / rating.totalVote) %"
            totalVoteLabel.text = "( \(rating.totalVote) )"
        } else {
            couponUpVote.text = ""
            couponDownVote.text = ""
            totalVoteLabel.text = ""
        }
        
        couponCodeImageView.image = Barcode.fromString(code: coupon.code)
        couPonDateLabel.text = "gültig bis \(FormattedDate.formatDateToString(coupon.date))"
        
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            if let ignoreList = coupon.ignoreForUser {
                if ignoreList.contains(uid) {
                    alreadsyUsedView.alpha = 1
                    isUserInteractionEnabled = false
                } else {
                    alreadsyUsedView.alpha = 0
                    isUserInteractionEnabled = true
                }
            }
        }
        
        self.delegate = delegate
        self.coupon = coupon
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if selected {
            delegate?.didSelectCoupon(for: self)
        }
        
    }
    
    
}
