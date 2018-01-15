//
//  ViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/12/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Title
    func setTitle(_ titleText: String, color: UIColor = UIColor.black) {
        
        let label = UILabel()
        label.text = titleText
        label.textColor = .black
        label.font = UIFont.defaultFont(style: .knockoutLiteweight, size: 20)
        
        label.sizeToFit()
        navigationItem.titleView = label
    }
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}
