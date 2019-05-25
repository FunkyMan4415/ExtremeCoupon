//
//  CouponIdentifier.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 24.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import Foundation

enum CouponMarket: String {
    
    case real, penny, aral, dm, rewe, customerNumber, undefined = "Unknown"
    
}

class CouponIdentifier {
    
    static func checkCouponNumber(couponNumber: String) -> CouponMarket? {
        let firstThreeChars = String(couponNumber.prefix(3))
        switch firstThreeChars {
        case "999":
            return CouponMarket.real
        case "229":
            return CouponMarket.penny
        case "923":
            return CouponMarket.dm
        case "981":
            return CouponMarket.aral
        case "227":
            return CouponMarket.rewe
        case "240":
            return CouponMarket.customerNumber
        default:
            return nil
        }
    }
}
