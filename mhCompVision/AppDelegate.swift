//
//  AppDelegate.swift
//  mhCompVision
//
//  Created by Vlad on 12/26/17.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import KeychainAccess

let AppWakeNotificationKey = "AppWakeNotificationKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Shared
    static let shared = UIApplication.shared.delegate as! AppDelegate

    /// Default keychain
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        window?.rootViewController = OnboardingContainerViewController()
        
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: AppWakeNotificationKey), object: nil)
    }
}

