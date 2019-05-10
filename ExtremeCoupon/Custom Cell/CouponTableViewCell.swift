//
//  CouponTableViewCell.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {
    @IBOutlet weak var couponTitleLabel: UILabel!
    @IBOutlet weak var couPonDateLabel: UILabel!
    @IBOutlet weak var couponRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
