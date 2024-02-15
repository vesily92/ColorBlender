//
//  ColorDescriptionView.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 15.02.2024.
//

import UIKit

final class ColorDescriptionView: UIView {
    
    let colorManager: IColorManager
    
    private lazy var colorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    private lazy var colorCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var redValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var greenValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var blueValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    init(colorManager: IColorManager) {
        self.colorManager = colorManager
        
        super.init(frame: .zero)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        let components = colorManager.getStringComponentsOf(color: color)
        let textColor = colorManager.checkIntensityOf(color: color)
        ? UIColor.black
        : UIColor.white
        
        colorNameLabel.text = color.accessibilityName.capitalized
        colorCodeLabel.text = colorManager.getColorCode(for: color)
        redValueLabel.text = "R: \(components.red)"
        greenValueLabel.text = "G: \(components.green)"
        blueValueLabel.text = "B: \(components.blue)"
        
        [colorNameLabel,
         colorCodeLabel,
         redValueLabel,
         greenValueLabel,
         blueValueLabel].forEach { $0.textColor = textColor }
    }
    
    private func setupConstraints() {
        let rgbStackView = UIStackView(arrangedSubviews: [
            redValueLabel,
            greenValueLabel,
            blueValueLabel
        ])
        rgbStackView.spacing = 20
        
        let stackView = UIStackView(arrangedSubviews: [
            colorNameLabel,
            colorCodeLabel,
            rgbStackView
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
