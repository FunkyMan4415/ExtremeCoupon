//
//  Coupon.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import Foundation


struct Coupon {
    let title: String
    let date: String
    let code: String
    let rating: Rating?
    // let market: String?
    
    
    
    static func loadCoupon(_ data: Dictionary<String, AnyObject>) -> Coupon? {
        guard let title = data["title"] as? String else { return nil }
        guard let date = data["date"] as? String else { return nil}
        guard let code = data["code"] as? String else { return nil}
        
     return Coupon(title: title, date: date, code: code, rating: nil)
    }
}
