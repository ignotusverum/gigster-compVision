//
//  APIManager.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Locksmith
import Alamofire
import PromiseKit
import SwiftyJSON

struct APIManagerJSON {
    static let authToken = "auth_token"
}

public class APIManager: NetworkingProtocol {
    
    /// Shared manger
    static let shared = APIManager()
    
    /// Header setup
    var headers = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]
    
    /// Api key
    var apiKey: String? {
        get {
            
            let keychain = AppDelegate.shared.keychain
            var accessTokenOld = keychain[NetworkingManagerAccessTokenKey]
            
            if let token = Locksmith.loadDataForUserAccount(userAccount: "UserToken")?["token"] as? String {
                accessTokenOld = token
            }
            
            return accessTokenOld
        }
        set {
            
            let keychain = AppDelegate.shared.keychain
            keychain[NetworkingManagerAccessTokenKey] = newValue
        }
    }
    
    /// Default manager setup
    var manager = Alamofire.SessionManager.default
    
    static let contentTypeString = "application/vnd.api+json"
    
    /// Header configuration
    func configureHeader() {
        
        /// Safety check
        guard let accessToken = apiKey, accessToken.count > 1 else {
            headers = [:]
            return
        }
        
        headers["Authorization"] = accessToken
        headers["Content-Type"] = APIManager.contentTypeString
    }
    
    /// Base URL setup
    func baseURL(path: String) -> URL {
        return URL(string: "https://\(hostName)/v\(hostVersion)/\(path)")!
    }
}
