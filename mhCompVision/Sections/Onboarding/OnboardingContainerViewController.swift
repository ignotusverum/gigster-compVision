//
//  OnboardingContainerViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/2/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import Foundation

class OnboardingContainerViewController: UIViewController {
    
    /// Page view controller
    lazy var pageVC: UIPageViewController = {
       
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.view.backgroundColor = UIColor.white
        
        return pageVC
    }()
    
    /// Datasource
    var controllers: [UIViewController] = []
}
