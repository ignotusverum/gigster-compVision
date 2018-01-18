//
//  JSON.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import SwiftyJSON

extension JSON {
    
    public var nsString: NSString? {
        
        switch type {
        case .string: return NSString(string: object as! String)
        default: return nil
        }
    }
    
    public var price: NSNumber? {
        
        switch type {
        case .number:
            
            let floatObject = Float(object as! Int)
            let priceDivider = Float(100)
            
            return NSNumber(value: floatObject/priceDivider)
        default:
            return nil
        }
    }
    
    public var json: JSON? {
        
        switch type {
        case .dictionary: return JSON(object)
        default: return nil
        }
    }
}
