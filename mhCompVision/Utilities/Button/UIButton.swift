//
//  UIButton.swift
//  mhCompVision
//
//  Created by Vlad on 1/8/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import Foundation

var ActionBlockKey: UInt8 = 0

// a type for our action block closure
typealias BlockButtonActionBlock = (_ sender: UIButton) -> Void

class ActionBlockWrapper : NSObject {
    var block : BlockButtonActionBlock
    init(block: @escaping BlockButtonActionBlock) {
        self.block = block
    }
}

extension UIButton {
    public func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func block_setAction(block: @escaping BlockButtonActionBlock, for control: UIControlEvents) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(UIButton.block_handleAction), for: .touchUpInside)
    }
    
    @objc func block_handleAction(sender: UIButton, for control:UIControlEvents) {
        
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender)
    }
}

