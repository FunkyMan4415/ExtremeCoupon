//
//  ProfileTableViewCell.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 29.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor(named: "background")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
