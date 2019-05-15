//
//  AddNewMarketViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 11.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

protocol AddNewMarketDelegate {
    func didUpdateNewMarket(_ market: Market)
}

class AddNewMarketViewController: UIViewController {
    @IBOutlet weak var marketTitle: RoundedTextField!
    
    var delegate: AddNewMarketDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addNewMarketButtonTapped(_ sender: RoundedButton) {
        let market = Market(uuid: NSUUID().uuidString, title: marketTitle.text!)
        FirebaseHelper.addNewMarket(market)
        delegate?.didUpdateNewMarket(market)
        self.navigationController?.popViewController(animated: true)
    }
}
