//
//  Settings.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 28.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import Foundation


enum Segues {
    static let couponDetail = "couponDetailSegue"
    static let filter = "filterSegue"
}

enum ReusableCells {
    static let couponCell = "CouponCell"
    static let profileCell = "ProfileCell"
}

class Settings {
}

extension Notification.Name {
    static let didReceiveInternet = Notification.Name("didReceiveInternet")
}
