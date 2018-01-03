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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard var index = controllers.index(of: viewController) else {
            return nil
        }
        
        index -= 1
        
        if index < 0 {
            return nil
        }
        
        return controllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard var index = controllers.index(of: viewController) else {
            return nil
        }
        
        index += 1
        
        if index == controllers.count {
            return nil
        }
        
        return controllers[index]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
