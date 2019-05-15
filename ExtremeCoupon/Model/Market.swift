//
//  Market.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 12.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import Foundation
import Firebase
class Market{
    let uuid: String
    let title: String
    
    
    init(uuid: String,title: String) {
        self.uuid = uuid
        self.title = title
    }
    
    static func loadMarket(_ data: Dictionary<String, AnyObject>) -> Market? {
        guard let uuid = data["uuid"] as? String else { return nil}
        guard let title = data["title"] as? String else { return nil}
        
        return Market(uuid: uuid, title: title)
    }
}
