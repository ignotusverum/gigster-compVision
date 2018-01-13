//
//  CameraViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/12/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import AVKit
import Foundation

class CameraViewController: UIViewController {
    
    lazy var cameraView: CameraView = CameraView()
    
    /// Empty view for camera permissions
    lazy var emptyView: EmptyView = EmptyView(title: "Please check your camera permissions in settings")
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.defaultFont(style: .knockoutLiteweight, size: 16)
        
        return label
    }()
    
    lazy var recordButton: UIButton = {
       
        let button = UIButton()
        button.setBackgroundColor(.defaultBlue, forState: .normal)
        button.addTarget(self, action: #selector(onRecord(_:)), for: .touchUpInside)
        
        return button
    }()
    
    /// Camera roll button
    lazy var galleryButton: UIButton = { [unowned self] in
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Gallery"), for: .normal)
        button.setBackgroundColor(.white, forState: .normal)
        button.addTarget(self, action: #selector(onGallery(_:)), for: .touchUpInside)
        
        return button
    }()
    
    /// Flashlight button
    lazy var flashButton: UIButton = { [unowned self] in
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Flash"), for: .normal)
        button.setBackgroundColor(.white, forState: .normal)
        button.addTarget(self, action: #selector(onFlash(_:)), for: .touchUpInside)
        
        return button
    }()
    
    /// Gallery image picker
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] response in
            DispatchQueue.main.sync {
                self.emptyViewLayout()
            }
        }
        
        /// Wake notification
        NotificationCenter.default.addObserver(self, selector: #selector(appDidWake), name: NSNotification.Name(rawValue: AppWakeNotificationKey), object: nil)
    }
    
    @objc func appDidWake() {
        emptyViewLayout()
    }
    
    private func layoutSetup() {
        
        view.backgroundColor = .black
        
        /// QR reader view layout
        view.addSubview(cameraView)
        cameraView.delegate = self
        cameraView.backgroundColor = .red
        cameraView.snp.makeConstraints { [unowned self] maker in
            maker.left.equalToSuperview().offset(40)
            maker.right.equalToSuperview().offset(-40)
            maker.height.equalTo(self.view.frame.width - 80)
            maker.bottom.equalToSuperview().offset(-200)
        }
        
        /// Flash button layout
        view.addSubview(flashButton)
        flashButton.snp.makeConstraints { [unowned self] maker in
            maker.bottom.equalTo(self.view).offset(-80)
            maker.centerX.equalTo(self.view).offset(-100)
            maker.width.height.equalTo(70)
        }
        
        /// Gallery button layout
        view.addSubview(galleryButton)
        galleryButton.snp.makeConstraints { [unowned self] maker in
            maker.bottom.equalTo(self.view).offset(-80)
            maker.centerX.equalTo(self.view).offset(100)
            maker.width.height.equalTo(70)
        }
        
        /// Record button
        view.addSubview(recordButton)
        recordButton.snp.makeConstraints { [unowned self] maker in
            maker.bottom.equalTo(self.view).offset(-30)
            maker.centerX.equalTo(self.view)
            maker.width.height.equalTo(80)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /// Layer updates
        flashButton.layer.cornerRadius = flashButton.frame.width / 2
        galleryButton.layer.cornerRadius = galleryButton.frame.width / 2
        
        flashButton.clipsToBounds = true
        galleryButton.clipsToBounds = true
        
        cameraView.layer.cornerRadius = cameraView.frame.width / 2
        cameraView.layer.masksToBounds = true
        
        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        recordButton.layer.masksToBounds = true
    }
    
    // MARK: Actions
    @objc
    private func onGallery(_ sender: UIButton?) {
        showGallery()
    }
    
    @objc
    private func onFlash(_ sender: UIButton?) {
        cameraView.toggleFlash()
    }
    
    @objc
    private func onRecord(_ sender: UIButton?) {
        cameraView.onTakePhoto()
    }
    
    // MARK: Utilities
    private func showGallery() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.isTranslucent = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func emptyViewLayout() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            /// Empty view setup
            if !view.subviews.contains(emptyView) {
                view.addSubview(emptyView)
                emptyView.snp.makeConstraints { [unowned self] maker in
                    maker.top.bottom.left.right.equalTo(self.view)
                }
            }
        }
    }
}

// MARK: ImagePickerController delegate
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true) { [unowned self] in
            
            /// Safety check
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage  else {
                return
            }
            
        }
    }
}

extension CameraViewController: CameraViewDelegate {
    func cameraView(_ cameraView: CameraView, imageOutput image: UIImage) {
        
    }
}