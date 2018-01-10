//
//  String.swift
//  mhCompVision
//
//  Created by Vlad on 1/9/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

import UIKit
import Foundation

extension String {
    
    func capitalizingFirst() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
