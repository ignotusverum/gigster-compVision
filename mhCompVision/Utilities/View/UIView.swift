//
//  UIView.swift
//  mhCompVision
//
//  Created by Vlad on 1/3/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
