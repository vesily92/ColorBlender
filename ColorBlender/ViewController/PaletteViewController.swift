//
//  PaletteViewController.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

final class PaletteViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, ColorModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ColorModel>
    
    private let colorManager: IColorManager
    
    private var backgroundIsLight: Bool!
    private var backgroundColor: UIColor! {
        didSet {
            backgroundIsLight = colorManager.checkIntensityOf(
                color: backgroundColor
            )
            setupBarButtonColor()
            view.backgroundColor = backgroundColor
        }
    }
    private var colorModels: [ColorModel] = [] {
        didSet {
            setBarButtonItemState()
            setupColors()
        }
    }
    
    private var chosenColor: UIColor = .white
    private var chosenIndexPath: IndexPath = [0, 0]
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    
    init(colorBlender: IColorManager, initialColors: [UIColor] = []) {
        self.colorManager = colorBlender
        super.init(nibName: nil, bundle: nil)
        
        backgroundColor = colorBlender.blend(colors: initialColors)
        backgroundIsLight = colorBlender.checkIntensityOf(color: backgroundColor)
        colorModels = map(colors: initialColors)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        view.backgroundColor = getBackgroundColor()
        setupCollectionView()
        createDataSource()
        
        dataSource?.apply(createSnapshot())
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView.isEditing = editing
        
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard let cell = collectionView
                .cellForItem(at: indexPath) as? ColorViewCell else {
                return
            }
            cell.isEditing = editing
                        
            UIView.animate(withDuration: 0.3) {
                cell.transform = editing
                ? CGAffineTransform(scaleX: 0.9, y: 0.9)
                : .identity
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.delegate = self
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
    
    private func setupBarButtonColor() {
        if backgroundIsLight {
            navigationItem.rightBarButtonItem?.tintColor = .black
            
        } else {
            navigationItem.rightBarButtonItem?.tintColor = .white
        }
    }
    
    private func setBarButtonItemState() {
        if colorModels.count < 2 {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationController?.setEditing(false, animated: true)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    private func setupColors() {
        backgroundColor = getBackgroundColor()
        
        if colorModels.last?.color != nil,
           colorModels.count < 9 {
            let emptyCell = EmptyCellModel(
                backgroundIsLight: backgroundIsLight
            )
            let colorModel = ColorModel.empty(emptyCell)
            colorModels.append(colorModel)
        }
    }
    
    private func presentColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Pick a color"
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        colorPicker.popoverPresentationController?.sourceItem = navigationItem.rightBarButtonItem
        present(colorPicker, animated: true)
    }
    
    private func getBackgroundColor() -> UIColor {
        var colors: [UIColor?] = []
        colorModels.forEach { colors.append($0.color) }
        
        let compactColors = colors.compactMap { $0 }
        
        guard !compactColors.isEmpty else { return .black }
        
        return colorManager
            .blend(colors: colors.compactMap { $0 })
    }
    
    private func map(colors: [UIColor]) -> [ColorModel] {
        var models: [ColorModel] = []
        
        if !colors.isEmpty {
            colors.forEach { color in
                let colorCellModel = ColorCellModel(color: color)
                let model = ColorModel.color(colorCellModel)
                models.append(model)
            }
        }
        let emptyCellModel = EmptyCellModel(backgroundIsLight: backgroundIsLight)
        let model = ColorModel.empty(emptyCellModel)
        models.append(model)
        return models
    }
    
    // MARK: CollectionView Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1 / 2)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: CollectionView Datasource
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, ColorModel>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, color in
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ColorViewCell.reuseIdentifier,
                    for: indexPath
                  ) as? ColorViewCell else {
                return UICollectionViewCell()
            }
            cell.onDistractionButtonDidTap = {
                if let index = self.colorModels
                    .firstIndex(where: { $0.id == color.id }) {
                    self.delete(at: index)
                }
            }
            cell.configure(
                with: color,
                isEditing: collectionView.isEditing
            )
            return cell
        }
    }
    
    private func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([1])
        snapshot.appendItems(colorModels)
        return snapshot
    }
    
    private func delete(at index: Int) {
        colorModels.remove(at: index)
        makeSnapshot(animated: true)
    }
    
    private func makeSnapshot(animated: Bool = true) {
        if let index = colorModels.firstIndex(where: { $0.backgroundIsLight != nil }) {
            colorModels[index].updateBackgroundIsLightValue(with: backgroundIsLight)
        }
        
        var snapshot = dataSource.snapshot()
        let difference = colorModels.difference(from: snapshot.itemIdentifiers)
        let currentIdentifiers = snapshot.itemIdentifiers
        
        guard let newIdentifiers = currentIdentifiers.applying(difference) else {
            return
        }
        snapshot.deleteItems(currentIdentifiers)
        snapshot.appendItems(newIdentifiers)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension PaletteViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if !collectionView.isEditing {
            presentColorPicker()
            chosenIndexPath = indexPath
        }
    }
}

// MARK: - UIColorPickerViewControllerDelegate

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
        let newColor = ColorCellModel(color: color)
        let newModel = ColorModel.color(newColor)
        
        colorModels.remove(at: chosenIndexPath.item)
        colorModels.insert(newModel, at: chosenIndexPath.item)
        
        makeSnapshot()
    }
}
