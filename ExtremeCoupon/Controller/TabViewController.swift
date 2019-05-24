//
//  TabViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 24.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "anonymousLogin") {
            if let items = tabbar.items {
                for item in items {
                    if item.title == "Neuen Coupon" {
                        item.isEnabled = false
                    }
                }
            }
        }
    }
}
