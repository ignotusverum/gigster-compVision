//
//  IngredientsAdapter.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import PromiseKit
import SwiftyJSON
import Foundation

class IngredientsAdapter {
    
    class func fetch()-> Promise<JSON> {
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "ingredients")
    }
}
