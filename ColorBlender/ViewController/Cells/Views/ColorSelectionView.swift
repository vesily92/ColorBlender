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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 16
        colorView.layer.cornerRadius = 10
    }
    
    func configure(with color: UIColor?) {
        if let color = color {
            colorLabel.text = color.accessibilityName.capitalized
            colorView.backgroundColor = color
        }
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
}

