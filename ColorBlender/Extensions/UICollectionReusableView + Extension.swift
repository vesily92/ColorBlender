//
//  UICollectionReusableView + Extension.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
