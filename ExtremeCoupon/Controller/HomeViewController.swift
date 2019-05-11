//
//  ViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 09.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var coupons = [
        Coupon(title: "8-Fach auf alles", date: "12.12.2019", code: "22950000000000000456", rating: Rating(upVote: 20, downVote: 0, totalVote: 20)),
        Coupon(title: "5-Fach auf Getränke", date: "23.06.2020", code: "22950000000000000456", rating: Rating(upVote: 50, downVote: 10, totalVote: 60)),
        Coupon(title: "10-Fach auf Autowäsche", date: "10.05.2019", code: "22950000000000000456", rating: Rating(upVote: 0, downVote: 0, totalVote: 0)),
        Coupon(title: "7-Fach auf Obst und Gemüse", date: "25.08.2022", code: "22950000000000000456", rating: Rating(upVote: 5, downVote: 20, totalVote: 25))
    ]
    var couponForSegue: Coupon?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
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
