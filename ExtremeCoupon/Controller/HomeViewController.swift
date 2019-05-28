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
import FirebaseAuth


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
     var observing = false
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: ReusableCells.couponCell, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ReusableCells.couponCell)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkInternet), name: .didReceiveInternet, object: nil)

        if Connectivity.isConnectedToInternet {
            SVProgressHUD.show(withStatus: "Lade Coupons")
            serverTime { (date) in
                self.today = date
                
                self.observing = self.load()
            }
        } else {
            SVProgressHUD.showInfo(withStatus: "Kein Internet, eingeschränkter Zugriff")
        }
    }
    
    @objc
    func checkInternet(_ notification: Notification) {
        if notification.object as! Bool {
            if !observing {
                
                
                SVProgressHUD.show(withStatus: "Lade Coupons")
                serverTime { (date) in
                    self.today = date
                    
                    _ = self.load()
                }
            }
        } else {
            SVProgressHUD.showInfo(withStatus: "Kein Internet, eingeschränkter Zugriff")
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
    
    
    func load() -> Bool{
        
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
            }
            self.filterCoupons()
        }
        return true
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
        SVProgressHUD.dismiss()
    }
    
    // MARK: - Handler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.couponDetail {
            if let coupon = couponForSegue {
                let detailVC = segue.destination as! CouponDetailViewController
                detailVC.coupon = coupon
            }
        }
        
        if segue.identifier == Segues.filter {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCells.couponCell, for: indexPath) as! CouponTableViewCell
        
        
        
        cell.configure(for: filteredCoupons[indexPath.row], and: self)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! CouponTableViewCell
        if cell.alreadsyUsedView.alpha == 1 {
            return nil
        }
        
        let conf: UISwipeActionsConfiguration!
        if Utility.isCouponAlreadyBookmarked(cell.coupon!.uuid) {
            let removeFromBookmarkAction = UIContextualAction(style: .normal, title: "Aus dem Merkzettel entfernen") { (action, view, completion) in
                Utility.deleteSelectedBookmark(cell.coupon!.uuid)
                SVProgressHUD.showSuccess(withStatus: "Coupon entfernt")
                SVProgressHUD.dismiss(withDelay: 1.0)
                completion(true)
            }
            removeFromBookmarkAction.backgroundColor = UIColor(named: "delete-color")
            conf = UISwipeActionsConfiguration(actions: [removeFromBookmarkAction])
        }else {
            let reportAction = UIContextualAction(style: .normal, title: "Zum Merkzettel") { (action, view, completion) in
                Utility.saveBookmark(cell.coupon, with: { (success) in
                    if success {
                        SVProgressHUD.showSuccess(withStatus: "Coupon zum Merkzettel hinzugefügt")
                        SVProgressHUD.dismiss(withDelay: 1.0)
                    } else {
                        SVProgressHUD.showError(withStatus: "Hups, da ist etwas schief gelaufen")
                        SVProgressHUD.dismiss(withDelay: 1.5)
                        completion(false)
                    }
                })
                
                completion(true)
            }
            reportAction.backgroundColor = UIColor(named: "accent-color")
            conf = UISwipeActionsConfiguration(actions: [reportAction])
        }
        
        
        conf.performsFirstActionWithFullSwipe = true
        return conf
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
//        let reportAction = UIContextualAction(style: .normal, title: "Melden") { (action, view, completion) in
//            Utility.showReportController(controller: self)
//            completion(true)
//        }
        
//        reportAction.backgroundColor = UIColor(displayP3Red: 160/255, green: 50/255, blue: 31/255, alpha: 1)
        return UISwipeActionsConfiguration(actions: [])
    }
    
}

extension HomeViewController : CouponTableViewCellDelegate {
    func didSelectCoupon(for cell: CouponTableViewCell) {
        if let coupon = cell.coupon {
            couponForSegue = coupon
            performSegue(withIdentifier: Segues.couponDetail, sender: self)
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
