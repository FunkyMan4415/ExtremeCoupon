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

enum CodingKeys: String, CodingKey {
    case uuid
    case title
    case date
    case code
    case rating
    case market
    case username
    case ignoreForUser
}

struct Coupon {
    var uuid: String
    var title: String
    var date: Date
    var code: String
    var rating: Rating?
    var market: String
    var username: String
    var ignoreForUser: [String]?
    
    static func loadCoupon(_ data: Dictionary<String, AnyObject>) -> Coupon? {
        guard let uuid = data["uuid"] as? String else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let unformattedDate = data["date"] as? String else { return nil}
        guard let code = data["code"] as? String else { return nil}
        guard let rating = data["Rating"] as? Dictionary<String, AnyObject> else {return nil}
        guard let market = data["market"] as? String else { return nil}
        
        var displayName = ""
        if let username = data["username"] as? String {
            displayName = username
        }
        
        var userList = [String]()
        if let ignoreDictionary = data["IgnoreCouponForUids"] as? Dictionary<String, AnyObject>  {
            for ignoreItem in ignoreDictionary {
                if let item = ignoreItem.value as? String {
                    userList.append(item)
                }
            }
        }
        
        let rate = Rating.loadRating(rating)
        let date = FormattedDate.formatStringToDate(unformattedDate)
        
        return Coupon(uuid: uuid, title: title, date: date, code: code, rating: rate, market: market, username: displayName, ignoreForUser: userList)
    }
}

extension Coupon : Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        uuid = try container.decode(String.self, forKey: .uuid)
        title = try container.decode(String.self, forKey: .title)
        date = try container.decode(Date.self, forKey: .date)
        code = try container.decode(String.self, forKey: .code)
        username = try container.decode(String.self, forKey: .username)
        market = try container.decode(String.self, forKey: .market)
        ignoreForUser = try container.decode([String].self, forKey: .ignoreForUser)
        
        let ratingData = try container.decode(Data.self, forKey: .rating)
        rating = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(ratingData) as? Rating ?? Rating.init()
        
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(uuid, forKey: .uuid)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(code, forKey: .code)
        try container.encode(username, forKey: .username)
        try container.encode(market, forKey: .market)
        try container.encode(ignoreForUser, forKey: .ignoreForUser)
        
        if let rate = rating {
            let rating = try NSKeyedArchiver.archivedData(withRootObject: rate, requiringSecureCoding: false)
            try container.encode(rating, forKey: .rating)
        }
    }
}
