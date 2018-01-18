//
//  IngredientsCollectionViewCell.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    var name: String? {
        didSet {
            guard let name = name else { return }
            nameLabel.text = name
            
            nameLabel.sizeToFit()
        }
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var checkBox: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.lightGray
        button.tintColor = UIColor.white
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var picked: Bool = false {
        didSet {
            if picked {
                checkBox.backgroundColor = UIColor.defaultBlue
                checkBox.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
                checkBox.layer.borderColor = UIColor.defaultBlue.cgColor
            } else {
                checkBox.backgroundColor = UIColor.lightGray
                checkBox.setImage(nil, for: .normal)
                checkBox.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    let borderLeftRightPadding: CGFloat = 20
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let borderWidth: CGFloat = 0.5
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: borderLeftRightPadding, y: frame.size.height - borderWidth, width: frame.size.width - 2*borderLeftRightPadding - 20, height: borderWidth)
        layer.addSublayer(border)
        
        addSubviews([
            nameLabel,
            checkBox
            ])
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(borderLeftRightPadding)
        }
        
        checkBox.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20 - borderLeftRightPadding)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(26)
        }
    }
}

