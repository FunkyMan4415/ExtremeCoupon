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
    
    @IBOutlet weak var scanArea: ScanView!
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
        
        let imgView = UIImageView()
        imgView.frame = CGRect(x: scanArea.bounds.minX, y: scanArea.bounds.minY, width: scanArea.frame.width, height: scanArea.frame.height)
        imgView.image = Barcode.fromString(code: "220000000000000456")
        imgView.alpha = 0.2
        
        scanArea.addSubview(imgView)
        view.addSubview(scanArea)
        view.bringSubviewToFront(scanArea)
        
        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: scanArea.frame)
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
