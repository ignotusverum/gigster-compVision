//
//  MainViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/9/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import StoreKit
import Foundation

enum TabTitles: String, CustomStringConvertible {
    case list
    case camera
    case favorite
    
    internal var description: String {
        return rawValue.capitalizingFirst()
    }
    
    static let allValues = [list, camera, favorite]
}

private var tabIcons = [
    TabTitles.list: "list",
    TabTitles.camera: "camera",
    TabTitles.favorite: "favorite"
]

class MainViewController: UITabBarController {
    
    lazy var listFlow: UINavigationController = {
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.black
        let timelineNavigation = UINavigationController(rootViewController: vc)
        timelineNavigation.navigationBar.isTranslucent = false
        
        return timelineNavigation
    }()
    
    lazy var cameraFlow: UINavigationController = {
        
        let vc = CameraViewController()
        let cameraNavigation = UINavigationController(rootViewController: vc)
        cameraNavigation.navigationBar.isTranslucent = false
        
        return cameraNavigation
    }()
    
    lazy var favoriteFlow: UINavigationController = {
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.green
        let notificationsNavigation = UINavigationController(rootViewController: vc)
        notificationsNavigation.navigationBar.isTranslucent = false
        
        return notificationsNavigation
    }()
    
    /// Tab bar controllers
    lazy var controllers: [UIViewController] = {
        
        /// Result controllers
        var resultControllers: [UIViewController] = []
        
        /// List
        resultControllers.append(self.listFlow)
        
        /// Camera
        resultControllers.append(self.cameraFlow)
        
        /// Favorite
        resultControllers.append(self.favoriteFlow)
        
        return resultControllers
    }()
    
    // MARK: - Contoller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Init controllers
        viewControllers = controllers
        
        selectedIndex = 1
        
        /// Setup tabbar
        setupTabBar()
    }
    
    // MARK: - Utilities
    /// Switcher logic
    ///
    /// - Parameter tabTitle: tab title
    func switchTo(title: TabTitles) {
        guard let index = TabTitles.allValues.index(of: title) else {
            return
        }
        
        /// Transition
        selectedIndex = index
    }
    
    /// Setup tabBar appearance
    private func setupTabBar() {
        
        /// Make it solid
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.black
        
        for (index, tabBarItem) in TabTitles.allValues.enumerated() {
            
            /// Safety check
            guard let item = tabBar.items?[index] else {
                return
            }
            
            item.image = UIImage(named: tabBarItem.description)
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.selectedImage = UIImage(named: "\(tabBarItem.description)_selected")
        }
    }
}
