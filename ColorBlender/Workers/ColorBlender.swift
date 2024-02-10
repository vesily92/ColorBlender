//
//  ColorBlender.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

protocol IColorBlender {
    func blend(colors: [UIColor]) -> UIColor
}

final class ColorBlender: IColorBlender {
    
    func blend(colors: [UIColor]) -> UIColor {
        let count = colors.count
        
        if !colors.isEmpty && count < 2 {
            return colors.first!
        }
        
        var ciColors: [CIColor] = []
        
        var redValues: [CGFloat] = []
        var greenValues: [CGFloat] = []
        var blueValues: [CGFloat] = []
        
        colors.forEach { color in
            ciColors.append(CIColor(color: color))
        }
        
        ciColors.forEach { color in
            redValues.append(color.red)
            greenValues.append(color.green)
            blueValues.append(color.blue)
        }
        
        let red = redValues.reduce(0, +) / CGFloat(count)
        let green = greenValues.reduce(0, +) / CGFloat(count)
        let blue = blueValues.reduce(0, +) / CGFloat(count)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

