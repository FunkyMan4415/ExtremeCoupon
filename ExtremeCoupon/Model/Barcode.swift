//
//  Barcode.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 11.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import CoreImage

class Barcode {
    class func fromString(code: String) -> UIImage? {
        let data = code.data(using: .ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            if let outputImage = filter.outputImage {
                
                let transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
                let scaled = outputImage.transformed(by: transform)
                
                
                return UIImage(ciImage: scaled)
            }
        }
        
        
        
        return nil
    }
}
