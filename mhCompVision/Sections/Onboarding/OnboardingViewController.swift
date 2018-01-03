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
    var titleString: String
    var descriptionString: String
    
    /// Background image
    lazy var backgroundImage: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// Title label
    lazy var titleLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    /// Description label
    lazy var descriptionLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    init(image: UIImage, title: String, description: String) {
        
        self.image = image
        self.titleString = title
        self.descriptionString = description
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// Setup UI
    func setupUI() {
        
        /// Background image
        view.addSubview(backgroundImage)
        backgroundImage.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.left.right.equalTo(self.view)
            maker.height.equalTo(self.view.snp.height).offset(0.8)
        }
        
        /// Title
        view.addSubview(titleLabel)
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(backgroundImage.snp.bottom).offset(5)
            maker.left.right.equalTo(self.view)
        }
        
        /// Description
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.updateConstraints { maker in
            maker.bottom.left.right.equalTo(self.view)
            maker.top.equalTo(titleLabel.snp.bottom)
        }
    }
}
