//
//  AdditionalColorSelectionView.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

final class AdditionalColorSelectionView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .white
        return imageView
    }()
    
    private var dashedBorderLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupBoarder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBoarder() {
        dashedBorderLayer.strokeColor = UIColor.white.cgColor
        dashedBorderLayer.lineDashPattern = [6, 4]
        dashedBorderLayer.lineWidth = 2
        dashedBorderLayer.frame = bounds
        dashedBorderLayer.fillColor = nil
        dashedBorderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        layer.addSublayer(dashedBorderLayer)
    }
}
