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
}
