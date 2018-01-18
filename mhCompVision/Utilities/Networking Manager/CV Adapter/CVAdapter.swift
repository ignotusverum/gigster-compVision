//
//  CVAdapter.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

class CVAdapter {
    
    class func create(url: String)-> Promise<JSON> {
        
        let params = ["url": url]
        
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "images", parameters: params)
    }
    
    class func fetch(id: Int)-> Promise<JSON> {
        
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "images/\(id)")
    }
}
