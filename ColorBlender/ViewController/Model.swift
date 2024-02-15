//
//  Model.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

struct Color: Hashable {
    
    let id = UUID()
    let color: UIColor?
}

struct ColorCellModel: Hashable {
    
    let id = UUID()
    let color: UIColor
}

struct EmptyCellModel: Hashable {
    
    let id = UUID()
    let backgroundIsLight: Bool
}

enum ColorModel: Hashable {
    
    case color(ColorCellModel)
    case empty(EmptyCellModel)
}

extension ColorModel {
    
    var id: UUID {
        switch self {
        case .color(let colorCellModel): colorCellModel.id
        case .empty(let emptyCellModel): emptyCellModel.id
        }
    }
    
    var color: UIColor? {
        switch self {
        case .color(let colorCellModel): colorCellModel.color
        case .empty(_): nil
        }
    }
    
    var backgroundIsLight: Bool? {
        switch self {
        case .color(_): nil
        case .empty(let emptyCellModel): emptyCellModel.backgroundIsLight
        }
    }

    mutating func updateBackgroundIsLightValue(with isLight: Bool) {
        switch self {
        case .color(_): break
        case .empty(_):
            self = .empty(EmptyCellModel(backgroundIsLight: isLight))
        }
    }
}
