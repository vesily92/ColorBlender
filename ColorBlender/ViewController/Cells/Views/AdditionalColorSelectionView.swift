//
//  AdditionalColorSelectionView.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

final class AdditionalColorSelectionView: UIView {
    
    private lazy var imageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 16,
            weight: .thin,
            scale: .default
        )
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus", withConfiguration: configuration)
        imageView.tintColor = .white
        return imageView
    }()
    
    private let dashedBorderLayer = CAShapeLayer()
    
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
        layer.addSublayer(dashedBorderLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupBoarder()
    }
    
    func configure(with backgroundIsLight: Bool) {
        if backgroundIsLight {
            imageView.tintColor = .systemGray
            dashedBorderLayer.strokeColor = UIColor.systemGray.cgColor
        } else {
            imageView.tintColor = .white
            dashedBorderLayer.strokeColor = UIColor.white.cgColor
        }
    }
    
    private func setupBoarder() {
        dashedBorderLayer.lineDashPattern = [6, 4]
        dashedBorderLayer.lineWidth = 1
        dashedBorderLayer.frame = bounds
        dashedBorderLayer.fillColor = nil
        dashedBorderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        layer.addSublayer(dashedBorderLayer)
    }
}
