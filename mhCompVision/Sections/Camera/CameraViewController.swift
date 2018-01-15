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
import Cloudinary

class CameraViewController: UIViewController {
    
    lazy var cameraView: CameraView = CameraView()
    
    /// Empty view for camera permissions
    lazy var emptyView: EmptyView = EmptyView(title: "Please check your camera permissions in settings")
    
    lazy var imageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

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
        
        view.backgroundColor = .white
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        paragraph.alignment = .center
        
        titleLabel.attributedText = NSAttributedString(string: "SCAN A FRUIT, VEGGIE OR BEVERAGE LABEL.", attributes: [NSAttributedStringKey.font: UIFont.defaultFont(style: .knockoutLiteweight, size: 20), NSAttributedStringKey.paragraphStyle: paragraph])
        
        view.addSubview(titleLabel)
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalToSuperview().offset(20)
            maker.left.equalToSuperview().offset(30)
            maker.right.equalToSuperview().offset(-30)
        }
        
        /// Camera view layout
        view.addSubview(cameraView)
        cameraView.delegate = self
        cameraView.backgroundColor = .red
        cameraView.snp.makeConstraints { [unowned self] maker in
            maker.left.equalToSuperview().offset(40)
            maker.right.equalToSuperview().offset(-40)
            maker.height.equalTo(self.view.frame.width - 80)
            maker.bottom.equalToSuperview().offset(-200)
        }
        
        /// Preview image
        view.addSubview(imageView)
        imageView.isHighlighted = true
        imageView.snp.makeConstraints { [unowned self] maker in
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
        imageView.makeRound()
        cameraView.makeRound()
        flashButton.makeRound()
        recordButton.makeRound()
        galleryButton.makeRound()
        
        galleryButton.layer.borderColor = UIColor.black.cgColor
        galleryButton.layer.borderWidth = 1
        
        flashButton.layer.borderColor = UIColor.black.cgColor
        flashButton.layer.borderWidth = 1
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
    
    func upload(_ data: Data) {
        
        guard let config = CLDConfiguration(cloudinaryUrl: "cloudinary://529747486124982:OeIXquTS7plUiErE4ygq6YTJdtA@hqhuesdz6") else {
            print("error")
            return
        }
        
        let cloudinary = CLDCloudinary(configuration: config)
        let params = CLDUploadRequestParams()
        
        flashButton.isHidden = true
        recordButton.isHidden = true
        galleryButton.isHidden = true
        
        let oldTitle = titleLabel.attributedText
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        paragraph.alignment = .center
        
        titleLabel.attributedText = NSAttributedString(string: "Scanning...", attributes: [NSAttributedStringKey.font: UIFont.defaultFont(style: .knockoutLiteweight, size: 20), NSAttributedStringKey.paragraphStyle: paragraph])
        
        cloudinary.createUploader().upload(data: data, uploadPreset: "vejjcwwj", params: params, progress: { (progress) in
            print(progress)
        }) { (result, error) in
            self.imageView.isHidden = true
            self.flashButton.isHidden = false
            self.recordButton.isHidden = false
            self.galleryButton.isHidden = false
            
            self.titleLabel.attributedText = oldTitle
            
            self.navigationController?.pushViewController(ConfirmationViewController(), animated: true)
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
            
            guard let data = UIImageJPEGRepresentation(image, 0.5) else {
                return
            }
            
            self.imageView.isHidden = false
            self.imageView.image = image
            
            self.upload(data)
        }
    }
}

extension CameraViewController: CameraViewDelegate {
    func cameraView(_ cameraView: CameraView, imageOutput image: UIImage) {
        
        guard let data = UIImageJPEGRepresentation(image, 0.5) else {
            return
        }
        
        imageView.isHidden = false
        imageView.image = image
        
        upload(data)
    }
}
