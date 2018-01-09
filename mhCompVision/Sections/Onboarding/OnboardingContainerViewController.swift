//
//  OnboardingContainerViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/2/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class OnboardingContainerViewController: UIViewController {
    
    var currentIndex = 0
    
    /// Page view controller
    lazy var pageVC: UIPageViewController = {
       
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.view.backgroundColor = UIColor.white
        
        return pageVC
    }()
    
    /// Page control
    lazy var pageControl: UIPageControl = {
       
        let pageControl = UIPageControl()
        
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .blue
        
        return pageControl
    }()
    
    fileprivate lazy var firstTutorialVC: OnboardingViewController = {
       
        let vc = OnboardingViewController(image: #imageLiteral(resourceName: "onboarding-1"), title: "THIRSTY?", description: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui.", buttonTitle: "SKIP")
        return vc
    }()
    
    fileprivate lazy var secondTutorialVC: OnboardingViewController = {
        
        let vc = OnboardingViewController(image: #imageLiteral(resourceName: "onboarding-2"), title: "SCAN INGREDIENTS", description: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui.", buttonTitle: "SKIP")
        return vc
    }()
    
    fileprivate lazy var thirdTutorialVC: OnboardingViewController = {
        
        let vc = OnboardingViewController(image: #imageLiteral(resourceName: "onboarding-3"), title: "BROWSE INGREDIENTS", description: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui.", buttonTitle: "MAKE SOME DRINKS", useLargeButton: true)
        
        return vc
    }()

    /// Datasource
    var controllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set page controller
        addChildViewController(pageVC)
        view.addSubview(pageVC.view)
        
        pageVC.delegate = self
        pageVC.dataSource = self
        
        /// Page controller layout
        pageVC.view.snp.updateConstraints { maker in
            maker.top.bottom.left.right.equalTo(self.view)
        }
        
        pageVC.didMove(toParentViewController: self)
        
        view.addSubview(pageControl)
        pageControl.snp.updateConstraints { maker in
            maker.bottom.equalToSuperview().offset(-30)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(40)
        }
        
        /// Update datasource
        datasourceSetup()
    }
    
    func datasourceSetup() {
        
        /// Handle actions
        firstTutorialVC.onButtonAction { [weak self] in
            self?.slideToPage(index: 1, completion: nil)
        }
        
        secondTutorialVC.onButtonAction { [weak self] in
            self?.slideToPage(index: 2, completion: nil)
        }
        
        thirdTutorialVC.onButtonAction {
            print("present login flow")
        }
        
        /// Setup pageVC
        controllers = [firstTutorialVC, secondTutorialVC, thirdTutorialVC]
        pageVC.setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
        
        
        /// Page control
        pageControl.numberOfPages = controllers.count
    }
    
    func slideToPage(index: Int, completion: (() -> Void)?) {
        
        if currentIndex < index {
            
            pageVC.setViewControllers([controllers[index]], direction: .forward, animated: true, completion: {[weak self] (complete: Bool) -> Void in
                
                self?.pageControl.currentPage = index
                self?.currentIndex = index
                completion?()
            })
        }
        else if currentIndex > index {
            pageVC.setViewControllers([controllers[index]], direction: .reverse, animated: true, completion: {[weak self] (complete: Bool) -> Void in
                
                self?.currentIndex = index
                self?.pageControl.currentPage = index
                completion?()
            })
        }
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

extension OnboardingContainerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            /// Safety check
            guard let viewController = pageViewController.viewControllers?[0], let index = controllers.index(of: viewController) else {
                return
            }
            
            pageControl.currentPage = index
            currentIndex = index
        }
    }
}
