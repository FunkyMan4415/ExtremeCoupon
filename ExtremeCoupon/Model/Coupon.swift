//
//  Coupon.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import Foundation

enum FormattedDate {
    static func formatStringToDate(_ text: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS Z"
        let date = dateFormatter.date(from: text)
        
        return date!
    }
    
    static func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
}


struct Coupon {
    let uuid: String
    let title: String
    var date: Date
    let code: String
    var rating: Rating?
    var market: String
    
    
    
    static func loadCoupon(_ data: Dictionary<String, AnyObject>) -> Coupon? {
        guard let uuid = data["uuid"] as? String else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let unformattedDate = data["date"] as? String else { return nil}
        guard let code = data["code"] as? String else { return nil}
        guard let rating = data["Rating"] as? Dictionary<String, AnyObject> else {return nil}
        guard let market = data["market"] as? String else { return nil}
        
        let rate = Rating.loadRating(rating)
        let date = FormattedDate.formatStringToDate(unformattedDate)
        
        return Coupon(uuid: uuid, title: title, date: date, code: code, rating: rate, market: market)
    }
}
