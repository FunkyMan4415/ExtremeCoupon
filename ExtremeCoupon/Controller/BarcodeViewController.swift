//
//  BarcodeViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 10.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeScannerDelegate {
    func didDetectedBarcode(for code: String?)
}

class BarcodeViewController: UIViewController {
    // MARK: - Properties
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView!
    var delegate: BarcodeScannerDelegate?
    
    // MARK: - Init
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
            metaDataOutput.metadataObjectTypes = [.code128]
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
        
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(white: 1, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height;
        let navigationbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: 44))
        let navigationItem = UINavigationItem()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissScanner))
        navigationbar.items = [navigationItem]
        navigationbar.backgroundColor = UIColor(white: 1, alpha: 1)
        view.addSubview(navigationbar)
        
        let scanAreaView = UIView()
        let width = view.bounds.width - 80
        scanAreaView.layer.borderColor = UIColor.green.cgColor
        scanAreaView.frame = CGRect(x: view.bounds.midX - (width/2), y: view.bounds.midY - 75, width: width, height: 150)
        scanAreaView.layer.borderWidth = 2
        view.addSubview(scanAreaView)
        view.bringSubviewToFront(scanAreaView)
        
        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: scanAreaView.frame)
        metaDataOutput.rectOfInterest = rectOfInterest
        
        
        
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
    
    func initCaptureSession(){
        
    }
    
    @objc
    func dismissScanner() {
        
            captureSession.stopRunning()
        
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Extensions
extension BarcodeViewController : AVCaptureMetadataOutputObjectsDelegate {
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
