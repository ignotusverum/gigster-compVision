//
//  UserAdapter.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import SwiftyJSON
import PromiseKit

class UserAdapter {
    
    class func authenticate()-> Promise<JSON> {
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "authenticate", parameters: ["id": "1", "password": "password"]).then { response-> JSON in
            
            if let authToken = response["auth_token"].string {
                
                apiMan.apiKey = authToken
            }
            
            return response
        }
    }
}
