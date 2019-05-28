//
//  Utility.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class Utility {
    static func showAlertController(for controller: UIViewController, with title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
//    static func showReportController(controller: UIViewController) {
//        let alertController = UIAlertController(title: "Coupon Melden", message: "Was stimmt mit dem Coupon, den du Meldest nicht?", preferredStyle: .actionSheet)
//        let actionTitle = UIAlertAction(title: "Falsche Überschrift", style: .default) { (action) in
//            showAlertController(for: controller, with: "Erfolgreich gesendet", and: "Danke, deine Meldung wird so schnell es geht bearbeitet!")
//        }
//        
//        let actionCode = UIAlertAction(title: "Ungültiger Code", style: .default) { (action) in
//            //
//        }
//        
//        let actionCancel = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
//        
//        alertController.addAction(actionTitle)
//        alertController.addAction(actionCode)
//        alertController.addAction(actionCancel)
//        controller.present(alertController, animated: true, completion: nil)
//        
//    }
    
    static func saveBookmark(_ coupons: [Coupon], removeFirstAllBookmarks: Bool) {
        if removeFirstAllBookmarks {
            UserDefaults.standard.set(nil, forKey: "bookmarks")
        }
        
        for c in coupons {
            saveBookmark(c) { (success) in
                //
            }
        }
    }
    
    static func saveBookmark(_ coupon: Coupon?, with completion: @escaping(Bool) -> () ) {
        if let coupon = coupon {
            let encoder = JSONEncoder()
            

            do {
                let encoded = try encoder.encode(coupon)
                if var bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? [Data] {
                    bookmarks.append(encoded)
                    UserDefaults.standard.set(bookmarks, forKey: "bookmarks")
                } else {
                    UserDefaults.standard.set([encoded], forKey: "bookmarks")
                }
                
            } catch {
                print("ERROR")
                completion(false)
            }
            completion(true)
        }
    }
    static func loadBookmarks() -> [Coupon] {
        var bookmarkedCoupons = [Coupon]()
        if let bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? [Data] {
            let decoder = JSONDecoder()
            for data in bookmarks {
                do {
                    let coupon = try decoder.decode(Coupon.self, from: data)
                    bookmarkedCoupons.append(coupon)
                } catch {
                    print("Something went wrong")
                }
            }
        }
        return bookmarkedCoupons
    }
    
    static func isCouponAlreadyBookmarked(_ uuid: String) -> Bool {
        let bookmarks = loadBookmarks()
        for bookmark in bookmarks {
            if bookmark.uuid == uuid {
                return true
            }
        }
        return false
    }
    
    static func deleteSelectedBookmark(_ uuid: String) {
        var bookmarks = loadBookmarks()
        bookmarks.removeAll { (coupon) -> Bool in
            coupon.uuid == uuid
        }
        
        saveBookmark(bookmarks, removeFirstAllBookmarks: true)
        
    }
    
    static func deleteBookmarks() {
        UserDefaults.standard.set(nil, forKey: "bookmarks")
    }
}
