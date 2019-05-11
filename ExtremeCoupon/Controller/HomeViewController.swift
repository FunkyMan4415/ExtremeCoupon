//
//  ViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import FirebaseDatabase


class HomeViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var coupons = [Coupon]()
    var couponForSegue: Coupon?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        
        
        FirebaseHelper.couponReference.observe(.value) { (snapshot) in
            self.coupons.removeAll()
            if let entries = snapshot.children.allObjects as? [DataSnapshot] {
                for entry in entries {
                    if let couponData = entry.value as? Dictionary<String, AnyObject> {
                        if let coupon = Coupon.loadCoupon(couponData) {
                            self.coupons.append(coupon)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Handler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "couponDetailSegue" {
            if let coupon = couponForSegue {
                let detailVC = segue.destination as! CouponDetailViewController
                detailVC.coupon = coupon
            }
        }
    }
    
}

    // MARK: - Extension
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponTableViewCell
        
        cell.configure(for: coupons[indexPath.row], and: self)
        return cell
    }
}

extension HomeViewController : CouponTableViewCellDelegate {
    func didSelectCoupon(for cell: CouponTableViewCell) {
        if let coupon = cell.coupon {
            couponForSegue = coupon
        }
    }
}
