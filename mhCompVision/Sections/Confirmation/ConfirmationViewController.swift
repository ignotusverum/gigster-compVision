//
//  ConfirmationViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/12/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation
import Kingfisher

class ConfirmationViewController: UIViewController {
    
    var json: JSON
    
    var fetchCount: Int = 0
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.defaultFont(style: .knockoutLiteweight, size: 16)
        
        return label
    }()
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
    
    init(json: JSON) {
        self.json = json
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_icon")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_icon")
        navigationController?.navigationBar.backItem?.title = ""
        
        setTitle("CONFIRM SCAN")
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        
        imageView.snp.updateConstraints { maker in
            maker.top.equalToSuperview().offset(100)
            maker.left.equalToSuperview().offset(50)
            maker.right.equalToSuperview().offset(-50)
            maker.height.equalTo(250)
        }
        
        
        
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).offset(40)
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
    
    func fetchData() {
        if let id = json["id"].int {
            
            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                let _ = CVAdapter.fetch(id: id).then { response-> Void in
                    self.json = response
                    print(response)
                    if response["categories"] == nil && self.fetchCount < 16 {
                        self.fetchData()
                        self.fetchCount += 1
                    }
                }
            }
        }
        
        if let urlString = json["url"].string, let url = URL(string: urlString) {
            print(url)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = #imageLiteral(resourceName: "question")
        }
        
        var string = "We cannot figure out what that is!"
        if let ingredients = json["ingredients"].array, let first = ingredients.first, let ingredient = first["ingredient"].json, let name = ingredient["name"].string {
            string = name
        } else {
            yesButton.setTitle("Try again", for: .normal)
            noButton.setTitle("Select ingredient", for: .normal)
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        paragraph.alignment = .center
        
        titleLabel.attributedText = NSAttributedString(string: string.uppercased(), attributes: [NSAttributedStringKey.font: UIFont.defaultFont(style: .knockoutLiteweight, size: 20), NSAttributedStringKey.paragraphStyle: paragraph])
    }
    
    @objc
    func onYes(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func onNo(_ sender: UIButton) {
        
        if let _ = json["ingredients"].array {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.pushViewController(IngredientsViewController(), animated: true)
        }
    }
}
