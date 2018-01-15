//
//  ConfirmationViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/12/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import Foundation

class ConfirmationViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.defaultFont(style: .knockoutLiteweight, size: 16)
        
        return label
    }()
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// Action button
    lazy var yesButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Yes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.defaultBlue, forState: .normal)
        button.addTarget(self, action: #selector(onYes), for: .touchUpInside)
        button.titleLabel?.font = UIFont.defaultFont(style: .tradeGothic, size: 10)
        
        return button
    }()
    
    /// Action button
    lazy var noButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("No", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.lightGray, forState: .normal)
        button.addTarget(self, action: #selector(onNo), for: .touchUpInside)
        button.titleLabel?.font = UIFont.defaultFont(style: .tradeGothic, size: 10)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_icon")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_icon")
        navigationController?.navigationBar.backItem?.title = ""
        
        setTitle("CONFIRM SCAN")
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "clementine")
        imageView.snp.updateConstraints { maker in
            maker.top.equalToSuperview().offset(150)
            maker.left.equalToSuperview().offset(50)
            maker.right.equalToSuperview().offset(-50)
            maker.width.height.equalTo(100)
        }
        
        view.addSubview(titleLabel)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        paragraph.alignment = .center
        
        titleLabel.attributedText = NSAttributedString(string: "Is this an orange?".uppercased(), attributes: [NSAttributedStringKey.font: UIFont.defaultFont(style: .knockoutLiteweight, size: 20), NSAttributedStringKey.paragraphStyle: paragraph])
        
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).offset(120)
            maker.left.equalToSuperview().offset(40)
            maker.right.equalToSuperview().offset(-40)
        }
        
        view.addSubviews([yesButton, noButton])
        yesButton.snp.updateConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(100)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(noButton.snp.top).offset(100)
        }
        
        noButton.snp.updateConstraints { maker in
            maker.top.equalTo(noButton.snp.top).offset(100)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
            maker.centerX.equalToSuperview()
        }
        
        noButton.layer.cornerRadius = 8
        noButton.clipsToBounds = true
        
        yesButton.layer.cornerRadius = 8
        yesButton.clipsToBounds = true
    }
    
    @objc
    func onYes(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func onNo(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
