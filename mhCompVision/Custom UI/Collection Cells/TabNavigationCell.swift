//
//  TabNavigationCell.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class TabNavigationCell: UICollectionViewCell {
    
    /// Type
    var type: TopNavigationDatasourceType! {
        didSet {
            
            /// Title
            titleLabel.text = type.rawValue
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.defaultFont(style: .tradeGothic, size: 14)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Title
        addSubview(titleLabel)
        
        /// Title layout
        titleLabel.snp.updateConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(self).offset(-1)
        }
    }
    
    /// Size calculation
    class func widthCalculation(type: TopNavigationDatasourceType)-> CGFloat {
        return type.rawValue.width(usingFont: UIFont.defaultFont(style: .tradeGothic, size: 14))
    }
}

