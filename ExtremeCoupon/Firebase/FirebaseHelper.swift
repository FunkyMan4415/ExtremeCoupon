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
    static let marketCache = NSCache<NSString, AnyObject>()
    private static var marketDatas = [Market]()
    
    static func newEntry(for coupon: Coupon) -> Dictionary<String, AnyObject>{
        let coupon = [
            "uuid" : coupon.uuid as AnyObject,
            "title" : coupon.title as AnyObject,
            "date" : coupon.date.description as AnyObject,
            "code" : coupon.code as AnyObject,
            "market": coupon.market as AnyObject,
            "username": coupon.username as AnyObject
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
    
    private static func newMarketEntry(for market: Market) -> Dictionary<String, AnyObject> {
        let market = [
            "uuid" : market.uuid as AnyObject,
            "title" : market.title as AnyObject
        ]
        
        return market
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
    
    static func deleteCoupon(_ coupon: Coupon) {
        couponReference.child(coupon.uuid).setValue(nil)
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
    
    static func addNewMarket(_ market: Market) {
        let id = marketReference.child(market.uuid)
        let marketEntry = newMarketEntry(for: market)
        id.setValue(marketEntry) { (error, databaseReference) in
            if let error = error {
                print("ERROR: \(#function): \(error.localizedDescription)")
            }
        }
    }
    
    static func getAllMarkets(completion: @escaping ([Market]) -> ()){
        var markets = [Market]()
       
        marketReference.observe(.value) { (snapshot) in
            marketDatas.removeAll()
            marketCache.removeAllObjects()
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                for entry in data {
                    if let entryData = entry.value as? Dictionary<String,AnyObject> {
                        if let marketData = Market.loadMarket(entryData) {
                            markets.append(marketData)
                            marketDatas.append(marketData)
                        }
                    }
                }
            }
            marketCache.setObject(marketDatas as AnyObject, forKey: "markets")
            completion(marketDatas)
        }
    }
    
    static func getCachedMarkets() -> [Market]? {
        if let cachedMarkets = marketCache.object(forKey: "markets") as? [Market] {
            return cachedMarkets
        } else {
            return nil
        }
    }
}
