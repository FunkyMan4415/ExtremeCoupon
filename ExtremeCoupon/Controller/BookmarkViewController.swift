//
//  BookmarkViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 27.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bookmarkedCoupons = [Coupon]()
    var couponForSegue: Coupon?
    let emptyView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: ReusableCells.couponCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReusableCells.couponCell)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }
    
    func loadBookmarks() {
        bookmarkedCoupons.removeAll()
        bookmarkedCoupons = Utility.loadBookmarks()
        self.tableView.reloadData()
    
        addEmptyBookmarkLabel(bookmarkedCoupons.isEmpty)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.couponDetail {
            if let coupon = couponForSegue {
                let detailVC = segue.destination as! CouponDetailViewController
                detailVC.delegate = self
                detailVC.coupon = coupon
            }
        }
        
    }
    
    @IBAction func deleteBookmarks(_ sender: Any) {
        Utility.deleteBookmarks()
        bookmarkedCoupons.removeAll()
        addEmptyBookmarkLabel(true)
        tableView.reloadData()
    }
    
    
    func addEmptyBookmarkLabel(_ emptyList: Bool) {
        
        if !emptyList {
            emptyView.removeFromSuperview()
            return
        }
        
        let textView = UITextView()
        emptyView.frame = CGRect(x: view.bounds.minX, y: view.bounds.midY - 50, width: view.bounds.width, height: 100)
        
        textView.frame = emptyView.bounds
        textView.backgroundColor = UIColor.clear
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textView.text = "Dein Merkzettel ist aktuell leer"
        textView.font = UIFont(name: "AvenirNext-Regular", size: 25)
        textView.adjustsFontForContentSizeCategory = true
        
        textView.textColor = UIColor.lightGray
        textView.textAlignment = .center
        
        emptyView.addSubview(textView)
        view.insertSubview(emptyView, at: 0)
        
        
    }
}


extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedCoupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCells.couponCell, for: indexPath) as! CouponTableViewCell
        
        cell.configure(for: bookmarkedCoupons[indexPath.row], and: self)
        return cell
    }
    
    
}

extension BookmarkViewController: CouponTableViewCellDelegate {
    func didSelectCoupon(for cell: CouponTableViewCell) {
        couponForSegue = cell.coupon
        performSegue(withIdentifier: Segues.couponDetail, sender: self)
    }
}

extension BookmarkViewController: CouponDetailViewDelegate {
    func didUsedCoupon(coupon: Coupon) {
        bookmarkedCoupons.removeAll { (c) -> Bool in
            c.uuid == coupon.uuid
        }
        
        Utility.saveBookmark(bookmarkedCoupons, removeFirstAllBookmarks: true)
        tableView.reloadData()
    }
    
}
