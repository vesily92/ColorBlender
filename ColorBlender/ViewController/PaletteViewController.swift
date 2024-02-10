//
//  PaletteViewController.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

final class PaletteViewController: UIViewController {
        
    private var colors: [UIColor?] = []
    
    private var chosenColor: UIColor = .white
    private var chosenIndexPath: IndexPath = [0, 0]
    
    private var collectionView: UICollectionView!
    private let colorBlender: IColorBlender
    
    init(colorBlender: IColorBlender, initialColors: [UIColor] = []) {
        self.colorBlender = colorBlender
        self.colors = initialColors
        self.colors.append(nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorBlender
            .blend(colors: colors.compactMap { $0 })
        setupCollectionView()
    }
    
    private func presentColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Pick a color!"
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        colorPicker.popoverPresentationController?.sourceItem = self.navigationItem.rightBarButtonItem
        self.present(colorPicker, animated: true)
    }
    
    private func updateColors(with color: UIColor, by index: Int) {
        colors.remove(at: index)
        colors.insert(color, at: index)
        
        if index == colors.count - 1 && colors.count < 9 {
            colors.append(nil)
            collectionView.reloadData()
        }
        
        view.backgroundColor = colorBlender
            .blend(colors: colors.compactMap { $0 })
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            ColorViewCell.self,
            forCellWithReuseIdentifier: ColorViewCell.reuseIdentifier
        )
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
}

extension PaletteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        let width = collectionView.bounds.width / 3 - layout.minimumInteritemSpacing - 8
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    }
}

extension PaletteViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        colors.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorViewCell.reuseIdentifier,
            for: indexPath
        ) as? ColorViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: colors[indexPath.item])
        
        return cell
    }
}

extension PaletteViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presentColorPicker()
        chosenIndexPath = indexPath
        
    }
}

extension PaletteViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(
        _ viewController: UIColorPickerViewController
    ) {
        dismiss(animated: true)
    }
    func colorPickerViewController(
        _ viewController: UIColorPickerViewController,
        didSelect color: UIColor,
        continuously: Bool
    ) {
        chosenColor = color
        guard let cell = collectionView.cellForItem(at: chosenIndexPath) as? ColorViewCell else {
            return
        }
        cell.configure(with: chosenColor)
        updateColors(with: color, by: chosenIndexPath.item)
    }
}
