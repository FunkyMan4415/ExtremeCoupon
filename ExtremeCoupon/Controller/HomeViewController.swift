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
    
    let coupons = [
        Coupon(title: "8-Fach auf alles", date: "12.12.2019", code: "9876543234567", rating: Rating(upVote: 20, downVote: 0, totalVote: 20)),
        Coupon(title: "5-Fach auf Getränke", date: "23.06.2020", code: "654323456798", rating: Rating(upVote: 50, downVote: 10, totalVote: 60)),
        Coupon(title: "10-Fach auf Autowäsche", date: "10.05.2019", code: "34328876467", rating: Rating(upVote: 0, downVote: 0, totalVote: 0)),
        Coupon(title: "7-Fach auf Obst und Gemüse", date: "25.08.2022", code: "25089683959", rating: Rating(upVote: 5, downVote: 20, totalVote: 25))
    ]
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    // MARK: - Handler
    
}

    // MARK: - Extension
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponTableViewCell
        
        cell.couponTitleLabel.text = coupons[indexPath.row].title
        cell.couponRatingLabel.text = "\(coupons[indexPath.row].rating.upVote) %"
        cell.couPonDateLabel.text = "gültig bis \(coupons[indexPath.row].date)"
        
        return cell
    }
    
    
}
