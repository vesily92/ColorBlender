//
//  ColorViewCell.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

final class ColorViewCell: UICollectionViewCell {
    
    private lazy var colorSelectionView = ColorSelectionView()
    private lazy var additionalColorSelectionView = AdditionalColorSelectionView()
    
    func configure(with color: UIColor?) {
        if let color = color {
            additionalColorSelectionView.removeFromSuperview()
            setup(colorSelectionView)
            colorSelectionView.configure(with: color)
            
        } else {
            colorSelectionView.removeFromSuperview()
            setup(additionalColorSelectionView)
        }
    }
    
    private func setup(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

