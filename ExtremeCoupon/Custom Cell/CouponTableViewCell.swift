//
//  CouponTableViewCell.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

protocol CouponTableViewCellDelegate {
    func didSelectCoupon(for cell: CouponTableViewCell)
}

class CouponTableViewCell: UITableViewCell {
    @IBOutlet weak var couponTitleLabel: UILabel!
    @IBOutlet weak var couPonDateLabel: UILabel!
    @IBOutlet weak var couponRatingLabel: UILabel!
    @IBOutlet weak var couponCodeImageView: UIImageView!
    
    var delegate: CouponTableViewCellDelegate?
    var coupon: Coupon?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(for coupon: Coupon, and delegate: CouponTableViewCellDelegate) {
        
        couponTitleLabel.text = coupon.title
        if let rating = coupon.rating, rating.totalVote > 0 {
            couponRatingLabel.text = "\(rating.upVote * 100 / rating.totalVote) %"
        }
        
        couponCodeImageView.image = Barcode.fromString(code: coupon.code)
        couPonDateLabel.text = "gültig bis \(FormattedDate.formatDateToString(coupon.date))"
        
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
