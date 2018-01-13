//
//  CameraView.swift
//  mhCompVision
//
//  Created by Vlad on 1/12/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import AVKit
import Foundation

protocol CameraViewDelegate {
    func cameraView(_ cameraView: CameraView, imageOutput image: UIImage)
}

class CameraView: UIView {
    
    var delegate: CameraViewDelegate?
    
    var device = AVCaptureDevice.default(for: .video)
    
    /// Photo capture
    lazy var captureSesssion : AVCaptureSession = AVCaptureSession()
    lazy var cameraOutput : AVCapturePhotoOutput = AVCapturePhotoOutput()
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    // MARK: Initialization
    init() {
        super.init(frame: .zero)
        
        cameraSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Preview layout
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = bounds
    }
    
    func cameraSetup() {
        
        captureSesssion.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let device = device else {
            return
        }
        
        if let input = try? AVCaptureDeviceInput(device: device) {
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(cameraOutput)) {
                    captureSesssion.addOutput(cameraOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    layer.addSublayer(previewLayer)
                    captureSesssion.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
    }
    
    func onTakePhoto() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: Utilities
    func toggleFlash() {
        
        /// Tourch is not available
        guard let device = device, device.hasTorch == true else {
            return
        }
        
        /// Toggle harware torch
        do {
            try device.lockForConfiguration()
            device.torchMode = device.torchMode == .on ? .off : .on
        } catch {
            print("configuration issues")
        }
    }
}

extension CameraView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size as Any)
            
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
            
            delegate?.cameraView(self, imageOutput: image)
        } else {
            print("some error here")
        }
    }
}
