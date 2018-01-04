//
//  AppDelegate.swift
//  mhCompVision
//
//  Created by Vlad on 12/26/17.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        window?.rootViewController = OnboardingContainerViewController()
        
        return true
    }
}

