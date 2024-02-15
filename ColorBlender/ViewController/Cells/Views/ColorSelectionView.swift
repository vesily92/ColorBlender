//
//  ColorSelectionView.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

final class ColorSelectionView: UIView {
            
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var outerBorderLayer = CAShapeLayer()
    private var innerBorderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        backgroundColor = .white
        layer.addSublayer(outerBorderLayer)
        layer.addSublayer(innerBorderLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 16
        colorView.layer.cornerRadius = 10

        setupOuterBoarder()
        setupInnerBoarder()
    }

    func configure(with color: UIColor) {
        colorLabel.text = color.accessibilityName.capitalized
        colorView.backgroundColor = color
    }
    
    private func setupConstraints() {
        addSubview(colorLabel)
        addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            colorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            colorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            colorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -16),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor)
        ])
    }
    
    private func setupOuterBoarder() {
        outerBorderLayer.strokeColor = UIColor.systemGray.cgColor
        outerBorderLayer.lineWidth = 0.5
        outerBorderLayer.frame = bounds
        outerBorderLayer.fillColor = nil
        outerBorderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
    }
    
    private func setupInnerBoarder() {
        innerBorderLayer.strokeColor = UIColor.systemGray.cgColor
        innerBorderLayer.lineWidth = 0.5
        innerBorderLayer.frame = bounds
        innerBorderLayer.fillColor = nil
        innerBorderLayer.path = UIBezierPath(roundedRect: colorView.frame, cornerRadius: 10).cgPath
    }
}

