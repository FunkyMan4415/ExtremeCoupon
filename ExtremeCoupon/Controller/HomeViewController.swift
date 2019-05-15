//
//  ViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD


class HomeViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterLabel: UILabel!
    
    var coupons = [Coupon]()
    var couponForSegue: Coupon?
    var filterText = [String]()
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        
        
        SVProgressHUD.show(withStatus: "Lade Coupons")
        
        FirebaseHelper.couponReference.observe(.value) { (snapshot) in
            self.coupons.removeAll()
            if let entries = snapshot.children.allObjects as? [DataSnapshot] {
                for entry in entries {
                    if let couponData = entry.value as? Dictionary<String, AnyObject> {
                        if let coupon = Coupon.loadCoupon(couponData) {
                            let currentDate = Calendar.current.startOfDay(for: Date())
                            if currentDate <= coupon.date {
                                self.coupons.append(coupon)
                            }
                        }
                    }
                }
            }
            
            self.coupons = self.coupons.sorted(by: { (c1, c2) -> Bool in
               c1.date < c2.date
            })
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
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
        
        if segue.identifier == "filterSegue" {
            let filterVC = segue.destination as! FilterViewController
            filterVC.delegate = self
            filterVC.selectedMarkets = filterText
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

extension HomeViewController : FilterDelegate {
    func didAddFilter(_ filter: String?) {
        filterText.append(filter!)
        filterLabel.text = filterText.joined(separator: ", ")
    }
    
    func didRemoveFilter(_ filter: String?) {
        for (index, _) in filterText.enumerated() {
            if filterText[index] == filter! {
                filterText.remove(at: index)
                filterLabel.text = filterText.joined(separator: ", ")
                return
            }
        }
    }
    
    
}
