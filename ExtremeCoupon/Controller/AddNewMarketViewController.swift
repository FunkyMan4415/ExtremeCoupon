//
//  AddNewMarketViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 11.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit

class AddNewMarketViewController: UIViewController {

    @IBOutlet weak var marketTitle: RoundedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("LOADED ADD NEW MARKET")
    }

    @IBAction func addNewMarketButtonTapped(_ sender: RoundedButton) {
        let market = Market(title: marketTitle.text!)
        FirebaseHelper.addNewMarket(market)
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
