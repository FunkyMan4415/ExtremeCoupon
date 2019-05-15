//
//  FirebaseHelper.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 11.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum FirebaseStrings {
    static let couponReference = "coupons"
    static let marketsReference = "markets"
}

enum FirebaseHelper {
    private static let databaseReference = Database.database().reference()
    static let couponReference = databaseReference.child(FirebaseStrings.couponReference)
    static let marketReference = databaseReference.child(FirebaseStrings.marketsReference)
    
    static func newEntry(for coupon: Coupon) -> Dictionary<String, AnyObject>{
        let coupon = [
            "uuid" : coupon.uuid as AnyObject,
            "title" : coupon.title as AnyObject,
            "date" : coupon.date.description as AnyObject,
            "code" : coupon.code as AnyObject
        ]
        
        return coupon
    }
    
    static func newRating(for rating: Rating?) -> Dictionary<String, AnyObject> {
        var rate = Rating()
        
        if rating != nil {
            rate = rating!
        }
        
        let rating = [
            "upVotes" : rate.upVote as AnyObject,
            "downVotes" : rate.downVote as AnyObject,
            "totalVotes" : rate.totalVote as AnyObject
        ]
        return rating
    }
    
    static func saveCoupon(_ coupon: Coupon) {
        let id = couponReference.child(coupon.uuid)
        let rating = id.child("Rating")
        id.setValue(newEntry(for: coupon)) { (error, databaseReference) in
            if let error = error {
                print("ERROR: \(#function): \(error.localizedDescription)")
            }
        }
        
        rating.setValue(newRating(for: coupon.rating)) { (error, databaseReference) in
            if let error = error {
                print("ERROR: \(#function): \(error.localizedDescription)")
            }
        }
    }
    
    static func updateCoupon(_ coupon: Coupon, with completion: @escaping(Bool) -> ()) {
        couponReference.child(coupon.uuid).updateChildValues(["Rating" : newRating(for: coupon.rating)]) { (error, databaseReference) in
            if let error = error {
                print("ERROR: \(#function): \(error.localizedDescription)")
            }
            completion(true)
        }
    }
    static func isCouponAlreadyInDatabase(_ searchedCoupon: Coupon, with completion: @escaping (Bool) -> ()) {
        couponReference.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                for entry in data {
                    if let entryData = entry.value as? Dictionary<String, AnyObject> {
                        if let coupon = Coupon.loadCoupon(entryData) {
                            if searchedCoupon.code == coupon.code {
                                completion(true)
                                return
                            }
                        }
                    }
                }
            }
            completion(false)
        }
    }
    
    private static func newMarketEntry(for market: Market) -> Dictionary<String, AnyObject> {
        let market = [
            "title" : market.title as AnyObject
        ]
        
        return market
    }
    static func addNewMarket(_ market: Market) {
        let id = marketReference.childByAutoId()
        let marketEntry = newMarketEntry(for: market)
        id.setValue(marketEntry) { (error, databaseReference) in
            if let error = error {
                print("ERROR: \(#function): \(error.localizedDescription)")
            }
        }
        
    }
    
    static func getAllMarkets(completion: @escaping ([Market]) -> ()){
        var markets = [Market]()
        marketReference.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                for entry in data {
                    if let entryData = entry.value as? Dictionary<String,AnyObject> {
                        if let title = entryData["title"] as? String {
                            markets.append(Market(title: title))
                        }
                    }
                }
            }
            completion(markets)
        }
    }
}
