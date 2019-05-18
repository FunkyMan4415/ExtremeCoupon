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
    var filteredCoupons = [Coupon]()
    var couponForSegue: Coupon?
    var filter: String?
    var filterValues = [String]()
    var today: Date!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        SVProgressHUD.show(withStatus: "Lade Coupons")
        serverTime { (date) in
            self.today = date
            
            self.load()
        }
    }
    
    func serverTime(completion: @escaping (_ getData: Date?) -> ()) {
        let url = URL(string: "https://www.google.com")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if let contentType = httpResponse.allHeaderFields["Date"] as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                        let serverTime = dateFormatter.date(from: contentType)
                        completion(serverTime!)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func load() {
        
        FirebaseHelper.couponReference.observe(.value) { (snapshot) in
            
            self.coupons.removeAll()
            if let entries = snapshot.children.allObjects as? [DataSnapshot] {
                for entry in entries {
                    if let couponData = entry.value as? Dictionary<String, AnyObject> {
                        if let coupon = Coupon.loadCoupon(couponData) {
                            let currentDate = Calendar.current.startOfDay(for: self.today)
                            if currentDate <= coupon.date {
                                self.coupons.append(coupon)
                            } else {
                                FirebaseHelper.deleteCoupon(coupon)
                            }
                        }
                    }
                }
                self.filterCoupons()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    
    func filterCoupons() {
        if filter != nil {
            filteredCoupons = coupons.filter({ (coupon) -> Bool in
                filterValues.contains(coupon.market)
            })
        } else {
            filteredCoupons = coupons
        }
        
        self.filteredCoupons = self.filteredCoupons.sorted(by: { (c1, c2) -> Bool in
            c1.date < c2.date
        })
        
        self.tableView.reloadData()
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
            filterVC.selectedMarkets = filterValues
        }
    }
    
}

// MARK: - Extension
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponTableViewCell
        
        cell.configure(for: filteredCoupons[indexPath.row], and: self)
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
    func didAddFilter(_ title: String, add: Bool) {
        if add {
            filterValues.append(title)
            filterLabel.text = filterValues.joined(separator: ", ")
            filter = "market"
        } else {
            for (i, value) in filterValues.enumerated() {
                if value == title {
                    filterValues.remove(at: i)
                    continue
                }
            }
            if filterValues.count == 0 {
                filter = nil
                filterLabel.text = "Kein Filer ausgewählt"
            } else {
                filterLabel.text = filterValues.joined(separator: ", ")
            }
        }
        filterCoupons()
    }
}
