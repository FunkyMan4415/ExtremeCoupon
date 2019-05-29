//
//  ScanViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 29.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanViewControllerDelegate {
    func didDetectedBarcode(for code: String?)
}

class ScanViewController: UIViewController {
    
    @IBOutlet weak var topbar: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView!
    var delegate: ScanViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else {
            return
        }
        
        captureSession = AVCaptureSession()
        
        
        // Video Input
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            Utility.showAlertController(for: self, with: "Fehler", and: "Oh nein, dein Gerät unterstützt das Scannen leider nicht :(")
            captureSession = nil
        }
        // MetadataOutput
        let metaDataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.code128, .ean13]
        } else {
            Utility.showAlertController(for: self, with: "Fehler", and: "Oh nein, dein Gerät unterstützt das Scannen leider nicht :(")
            captureSession = nil
        }
        
        // Preview Layer
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        let scanAreaView = UIView()
        let width = view.bounds.width - 80
        
        scanAreaView.frame = CGRect(x: view.bounds.midX - (width/2), y: view.bounds.midY - 75, width: width, height: 150)
        
        insertSublayers(scanAreaView)
        view.addSubview(scanAreaView)
        view.bringSubviewToFront(scanAreaView)
        
        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: scanAreaView.frame)
        metaDataOutput.rectOfInterest = rectOfInterest
        
        view.bringSubviewToFront(topbar)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
            
        }
    }
    
    // MARK: - Handlers
    func insertSublayers(_ subV: UIView) {
        let layerOne = CALayer()
        layerOne.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
        layerOne.frame = CGRect(x: subV.bounds.minX, y: subV.bounds.minY - 5, width: 50, height: 5)
        
        let layerFive = CALayer()
        layerFive.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
        layerFive.frame = CGRect(x: subV.bounds.minX - 5, y: subV.bounds.minY - 5, width: 5, height: 50)
        
        
        let layerThree = CALayer()
        layerThree.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
        layerThree.frame = CGRect(x: subV.bounds.maxX - 50, y: subV.bounds.minY - 5, width: 50, height: 5)
        
        let layerSix = CALayer()
        layerSix.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
        layerSix.frame = CGRect(x: subV.bounds.maxX, y: subV.bounds.minY - 5, width: 5, height: 50)
        
        
        let layerTwo = CALayer()
        layerTwo.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
        layerTwo.frame = CGRect(x: subV.bounds.maxX - 50, y: subV.bounds.maxY, width: 50, height: 5)
        
        let layerSeven = CALayer()
        layerSeven.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
        layerSeven.frame = CGRect(x: subV.bounds.maxX, y: subV.bounds.maxY - 45, width: 5, height: 50)
        
        let layerFour = CALayer()
        layerFour.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
        layerFour.frame = CGRect(x: subV.bounds.minX, y: subV.bounds.maxY, width: 50, height: 5)
        
        let layerEight = CALayer()
        layerEight.backgroundColor = UIColor(white: 0.667, alpha: 0.5).cgColor
        
        layerEight.frame = CGRect(x: subV.bounds.minX - 5, y: subV.bounds.maxY - 45, width: 5, height: 50)
        
        
        subV.layer.addSublayer(layerOne)
        subV.layer.addSublayer(layerTwo)
        subV.layer.addSublayer(layerThree)
        subV.layer.addSublayer(layerFour)
        subV.layer.addSublayer(layerFive)
        subV.layer.addSublayer(layerSix)
        subV.layer.addSublayer(layerSeven)
        subV.layer.addSublayer(layerEight)
        
        
        
        let imgView = UIImageView()
        imgView.frame = CGRect(x: subV.bounds.minX, y: subV.bounds.minY, width: subV.frame.width, height: subV.frame.height)
        imgView.image = Barcode.fromString(code: "220000000000000456")
        imgView.alpha = 0.2
        subV.addSubview(imgView)
    }
    
    func initCaptureSession(){
        
    }
    @IBAction func dismissScannView(_ sender: Any) {
        dismissScanner()
    }
    
    @objc
    func dismissScanner() {
        
        captureSession.stopRunning()
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            delegate?.didDetectedBarcode(for: stringValue)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
