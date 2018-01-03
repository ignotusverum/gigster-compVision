//
//  Font.swift
//  mhCompVision
//
//  Created by Vlad on 1/3/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import Foundation

enum FontStyle: String {
    
    case tradeGothic = "TradeGothic"
    case tradeGothicBold = "TradeGothic-Bold"
    
    case knockoutLiteweight = "Knockout-HTF29-JuniorLiteweight"
}

extension UIFont {
    
    /// Default font setup
    static func defaultFont(style: FontStyle = .regular, size: CGFloat = 14)-> UIFont {
        return UIFont(name: "\(style.rawValue.capitalizedFirst())", size: fontScalingSize(size))!
    }
    
    // MARK: - Scaling logic
    class func fontScalingSize(_ size: CGFloat)-> CGFloat {
        
        switch UIDevice().screenType {
        case .iPhone4, .iPhone5:
            return size - 3
        case .iPhone6Plus:
            return size + 3
        default:
            return size
        }
    }
}
