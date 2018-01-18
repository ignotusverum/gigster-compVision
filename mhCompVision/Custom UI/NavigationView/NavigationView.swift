//
//  NavigationView.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import Foundation

protocol TopNavigationViewDelegate {
    
    /// Called when tab selected
    func onTab(_ selectedType: TopNavigationDatasourceType)
}

enum TopNavigationDatasourceType: String {
    case mixers = "Mixers"
    case liquors = "Liquors"
    case fruits = "Fruits"
}

class TopNavigationView: UIView {
    
    /// Datasource
    var datasource: [TopNavigationDatasourceType] = []
    
    /// Delegate
    var delegate: TopNavigationViewDelegate?
    
    /// Selected type
    var selectedType: TopNavigationDatasourceType = .mixers {
        didSet {
            
            delegate?.onTab(selectedType)
        }
    }
    
    /// Selection view
    lazy var selectionView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.defaultBlue
        
        return view
    }()
    
    /// Collection View
    var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = UIColor.white
        
        /// Cell registration
        collectionView.register(TabNavigationCell.self, forCellWithReuseIdentifier: "\(TabNavigationCell.self)")
        
        return collectionView
    }()
    
    var width: CGFloat = 0
    
    // MARK: - Initialization
    init(width: CGFloat) {
        self.width = width
        super.init(frame: .zero)
        
        /// Datasource setup
        datasourceSetup()
        
        /// Custom init
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("TopNavigationView not implemented aDecoder")
    }
    
    // MARK: - Custom init
    func datasourceSetup() {
        
        datasource = []
        datasource.append(.mixers)
        datasource.append(.liquors)
        datasource.append(.fruits)
        
        selectedType = .mixers
    }
    
    private func customInit() {
        
        /// Color
        collectionView.backgroundColor = UIColor.clear
        
        /// Collection view
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
        
        /// Selection view
        addSubview(selectionView)
        
        /// Slection view layout
        updateSelection()
    }
    
    // MARK: - Utilities
    func updateSelection(scrollingPosition: CGFloat = 0.0) {
        
        /// Current width
        let width = self.width / CGFloat(datasource.count)
        
        /// Left position
        var leftPosition: CGFloat = 0
        
        /// User for touch event
        if scrollingPosition == 0.0 {
            
            /// Current index
            let currentIndex = datasource.index(of: selectedType) ?? 0
            for (i, _) in datasource.enumerated() {
                if currentIndex - 1 >= 0 && i != currentIndex && currentIndex > i {
                    
                    leftPosition += width
                }
            }
        }
        else {
            /// Scrolling position - scroll view delegate
            leftPosition = scrollingPosition + width
        }
        
        /// Animation
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseIn
            , animations: {
                
                /// Selection view layout
                self.selectionView.snp.updateConstraints { maker in
                    maker.left.equalTo(leftPosition)
                    maker.width.equalTo(width)
                    maker.bottom.equalTo(self)
                    maker.height.equalTo(3)
                }
                
                self.layoutSubviews()
        }, completion: nil)
    }
}

// MARK: - CollectionView Datasource
extension TopNavigationView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: self.width / CGFloat(datasource.count), height: collectionView.frame.height)
    }
}

// MARK: - CollectionView Delegate
extension TopNavigationView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// Update selection view
        let type = datasource[indexPath.row]
        selectedType = type
        updateSelection()
    }
}

// MARK: - CollectionView Datasource
extension TopNavigationView: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TabNavigationCell.self)", for: indexPath) as! TabNavigationCell
        
        let type = datasource[indexPath.row]
        cell.type = type
        
        return cell
    }
}

