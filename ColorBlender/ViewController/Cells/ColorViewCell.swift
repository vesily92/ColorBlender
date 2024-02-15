//
//  ColorViewCell.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

final class ColorViewCell: UICollectionViewCell {
    
    var onDistractionButtonDidTap: (() -> Void)?
    
    var isEditing: Bool = false {
        didSet {
            additionalColorSelectionView.isHidden = isEditing
            distractionButton.isHidden = !isEditing
            animate()
        }
    }
    
    private lazy var colorSelectionView = ColorSelectionView()
    private lazy var additionalColorSelectionView = AdditionalColorSelectionView()
    private lazy var distractionButton: UIButton = createDistractionButton()

    private var color: UIColor? = nil
        
    func configure(with color: ColorModel, isEditing: Bool) {
        self.color = color.color
        
        switch color {
        case .color(let colorCellModel):
            additionalColorSelectionView.removeFromSuperview()
            setup(colorSelectionView)
            colorSelectionView.configure(with: colorCellModel.color)
            setupDistractionButton()
            
        case .empty(let emptyCellModel):
            colorSelectionView.removeFromSuperview()
            distractionButton.removeFromSuperview()
            additionalColorSelectionView.isHidden = false
            additionalColorSelectionView.configure(
                with: emptyCellModel.backgroundIsLight
            )
            additionalColorSelectionView.isHidden = isEditing
            
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
    
    private func createDistractionButton() -> UIButton {
        let removeButton = UIButton()
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 20,
            weight: .bold,
            scale: .large
        )
        let image = UIImage(
            systemName: "minus.circle.fill",
            withConfiguration: configuration
        )?.withRenderingMode(.alwaysOriginal)
        let action = UIAction { [weak self] action in
            self?.onDistractionButtonDidTap?()
        }
        removeButton.addAction(action, for: .touchUpInside)
        removeButton.setImage(image, for: .normal)
        
        return removeButton
    }
    
    private func setupDistractionButton() {
        distractionButton.isHidden = true
        distractionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(distractionButton)
        
        NSLayoutConstraint.activate([
            distractionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            distractionButton.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            
            distractionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            distractionButton.heightAnchor.constraint(equalTo: distractionButton.widthAnchor)
        ])
    }
    
    private func animate() {
        guard color != nil else { return }

        if isEditing {
            startWigglingAnimation()
        } else {
            stopWigglingAnimation()
        }
    }
    
    private func startWigglingAnimation() {
        let duration: Double = 0.4
        let displacement: CGFloat = 1.5
        let degreesRotation: CGFloat = 0.8
        let negativeDisplacement = -1.0 * displacement
        
        let position = CAKeyframeAnimation.init(keyPath: "position")
        position.beginTime = 0.8
        position.duration = duration
        position.values = [
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement)),
            NSValue(cgPoint: CGPoint(x: 0, y: 0)),
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: 0)),
            NSValue(cgPoint: CGPoint(x: 0, y: negativeDisplacement)),
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement))
        ]
        position.isRemovedOnCompletion = false
        position.repeatCount = Float.greatestFiniteMagnitude
        position.beginTime = CFTimeInterval(
            Float(arc4random())
                .truncatingRemainder(dividingBy: Float(25)) / Float(100)
        )
        position.isAdditive = true
        
        let transform = CAKeyframeAnimation.init(keyPath: "transform")
        transform.beginTime = 2.6
        transform.duration = duration
        transform.valueFunction = CAValueFunction(
            name: .rotateZ
        )
        transform.values = [
            .pi * (-1.0 * degreesRotation) / 180.0,
            .pi * degreesRotation / 180.0,
            .pi * (-1.0 * degreesRotation) / 180.0
        ]
        transform.isRemovedOnCompletion = false
        transform.repeatCount = Float.greatestFiniteMagnitude
        transform.isAdditive = true
        transform.beginTime = CFTimeInterval(
            Float(arc4random())
                .truncatingRemainder(dividingBy: Float(25)) / Float(100)
        )
        
        layer.add(position, forKey: nil)
        layer.add(transform, forKey: nil)
    }
    
    private func stopWigglingAnimation() {
        layer.removeAllAnimations()
    }
}

