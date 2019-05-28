//
//  Connectivity.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 28.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    static let shared = Connectivity()
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    let networkReachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.de")
    
    func startNetworkReachabilityObserver() {
        networkReachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                NotificationCenter.default.post(name: .didReceiveInternet, object: false)
            case .unknown, .reachable(_) :
                NotificationCenter.default.post(name: .didReceiveInternet, object: true)
            }
        }
        
        // start listening
        networkReachabilityManager?.startListening()
    }
}
