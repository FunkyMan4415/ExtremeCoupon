//
//  Rating.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import Foundation

class Rating: NSObject, NSCoding {
    
    var upVote: Int
    var downVote: Int
    var totalVote: Int
    
   override init() {
        self.upVote = 0
        self.downVote = 0
        self.totalVote = 0
    }
    
    init(upVotes: Int, downVotes: Int, totalVotes: Int) {
        self.upVote = upVotes
        self.downVote = downVotes
        self.totalVote = totalVotes
    }
    
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.upVote, forKey: "upVote")
        aCoder.encode(self.downVote, forKey: "downVote")
        aCoder.encode(self.totalVote, forKey: "totalVote")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.upVote = aDecoder.decodeInteger(forKey: "upVote")
        self.downVote = aDecoder.decodeInteger(forKey: "downVote")
        self.totalVote = aDecoder.decodeInteger(forKey: "totalVote")
    }
    
    
    static func loadRating(_ data: Dictionary<String, AnyObject>) -> Rating? {
        guard let up = data["upVotes"] as? Int else { return nil }
        guard let down = data["downVotes"] as? Int else { return nil }
        guard let total = data["totalVotes"] as? Int else { return nil }
        
        return Rating(upVotes: up, downVotes: down, totalVotes: total)
    }
}
