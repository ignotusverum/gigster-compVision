//
//  TutorialViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/12/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import Foundation

class TutorialViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.defaultFont(style: .knockoutLiteweight, size: 16)
        
        return label
    }()
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// Action button
    lazy var actionButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Got it", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.defaultBlue, forState: .normal)
        button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.defaultFont(style: .tradeGothic, size: 10)
        
        return button
    }()
    
    var titleString: String
    var image: UIImage
    var onDone: (()->())
    
    init(title: String, image: UIImage, onDoneButton: @escaping (()->())) {
        
        self.titleString = title
        self.image = image
        self.onDone = onDoneButton
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
    }
    
    private func layoutSetup() {
        
        view.backgroundColor = UIColor.init(hexString: "#384044")
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        paragraph.alignment = .center
        
        titleLabel.attributedText = NSAttributedString(string: titleString, attributes: [NSAttributedStringKey.font: UIFont.defaultFont(style: .knockoutLiteweight, size: 30), NSAttributedStringKey.paragraphStyle: paragraph])

        view.addSubviews([titleLabel, actionButton, imageView])
        
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalToSuperview().offset(80)
            maker.left.equalToSuperview().offset(30)
            maker.right.equalToSuperview().offset(-30)
        }
        
        imageView.image = image
        imageView.snp.updateConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(40)
            maker.left.equalToSuperview().offset(40)
            maker.right.equalToSuperview().offset(-40)
            maker.bottom.equalTo(actionButton.snp.top).offset(-80)
        }
        
        /// Action button
        actionButton.snp.updateConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.height.equalTo(40)
            maker.width.equalTo(140)
            maker.bottom.equalToSuperview().offset(-80)
        }
        
        actionButton.layer.borderWidth = 1
        actionButton.layer.cornerRadius = 8
        actionButton.layer.masksToBounds = true
        actionButton.layer.borderColor = UIColor.defaultBlue.cgColor
    }
    
    @objc
    func onButton() {
        onDone()
    }
}
