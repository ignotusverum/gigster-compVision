//
//  OnboardingViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/2/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class OnboardingViewController: UIViewController {
    
    var image: UIImage
    var buttonTitle: String
    var titleString: String
    var descriptionString: String
    
    /// Action handler
    private var onAction: (()->())?
    
    /// Background image
    lazy var backgroundImage: UIImageView = {
       
        let imageView = UIImageView()
        return imageView
    }()
    
    /// Action button
    lazy var actionButton: UIButton = {
       
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(style: .tradeGothic, size: 10)
        return button
    }()
    
    /// Title label
    lazy var titleLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.defaultFont(style: .knockoutLiteweight, size: 40)
        return label
    }()
    
    /// Description label
    lazy var descriptionLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.defaultFont(style: .tradeGothic, size: 16)
        return label
    }()
    
    init(image: UIImage, title: String, description: String, buttonTitle: String) {
        
        self.image = image
        self.titleString = title
        self.buttonTitle = buttonTitle
        self.descriptionString = description
        
        super.init(nibName: nil, bundle: nil)

        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        
        backgroundImage.image = image
        titleLabel.text = titleString
        descriptionLabel.text = descriptionString
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    /// Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// Setup UI
    func setupUI() {
        
        view.addSubviews([backgroundImage, titleLabel, descriptionLabel, actionButton])
        
        /// Background image
        backgroundImage.snp.updateConstraints { maker in
            maker.top.equalTo(self.view).offset(40)
            maker.left.right.equalTo(self.view)
            maker.height.equalToSuperview().multipliedBy(0.5)
        }
        
        /// Title
        titleLabel.sizeToFit()
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(backgroundImage.snp.bottom).offset(20)
            maker.left.right.equalTo(self.view)
            maker.height.equalTo(40)
        }
        
        /// Description
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.updateConstraints { maker in
            maker.left.equalToSuperview().offset(40)
            maker.right.equalToSuperview().offset(-40)
            maker.top.equalTo(titleLabel.snp.bottom).offset(40)
        }

        /// Action button
        actionButton.snp.updateConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.height.equalTo(40)
            maker.width.equalTo(140)
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(40)
        }
        
        actionButton.layer.cornerRadius = 8
        actionButton.layer.masksToBounds = true
        actionButton.layer.borderColor = UIColor.blue.cgColor
        actionButton.layer.borderWidth = 1
        
        actionButton.addTarget(self, action: #selector(onButton), for: .touchUpInside)
    }
    
    /// Utilities
    func onButtonAction(_ action: @escaping (()->())) {
        self.onAction = action
    }
    
    @objc func onButton() {
        onAction?()
    }
}
