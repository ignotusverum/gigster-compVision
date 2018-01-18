//
//  IngredientsViewController.swift
//  mhCompVision
//
//  Created by Vlad on 1/15/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class IngredientsViewController: UIViewController {
    
    /// Tab switcher view
    lazy var tabSwitcherView: TopNavigationView = {
        
        /// Tab switcher view
        let tabSwitcherView = TopNavigationView(width: self.view.frame.width)
        tabSwitcherView.backgroundColor = UIColor.lightGray
        
        return tabSwitcherView
    }()
    
    lazy var collectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        
        view.register(IngredientsCollectionViewCell.self, forCellWithReuseIdentifier: "\(IngredientsCollectionViewCell.self)")
        
        return view
    }()
    
    var datasource: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setTitle("SELECT INGREDIENTS")
        
        /// Add tab switcher components
        view.addSubview(tabSwitcherView)
        tabSwitcherView.delegate = self
        
        tabSwitcherView.snp.updateConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(50)
        }
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(tabSwitcherView.snp.bottom)
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(self.view).offset(57)
        }
        
        IngredientsAdapter.fetch().then { response-> Void in
            self.datasource = response.array ?? []
            self.collectionView.reloadData()
        }
    }
}

extension IngredientsViewController: TopNavigationViewDelegate {
    /// Called when tab selected
    func onTab(_ selectedType: TopNavigationDatasourceType) {
        print(selectedType)
    }
}

extension IngredientsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension IngredientsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! IngredientsCollectionViewCell
        cell.picked = !cell.picked
    }
}

extension IngredientsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(IngredientsCollectionViewCell.self)", for: indexPath) as! IngredientsCollectionViewCell
        cell.name = item["name"].string
        
        return cell
        
    }
}
