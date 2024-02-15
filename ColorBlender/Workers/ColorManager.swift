//
//  ColorBlender.swift
//  ColorBlender
//
//  Created by Vasilii Pronin on 10.02.2024.
//

import UIKit

protocol IColorManager {
    func blend(colors: [UIColor]) -> UIColor
    func checkIntensityOf(color: UIColor) -> Bool
}

final class ColorManager: IColorManager {
    
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
    
    func checkIntensityOf(color: UIColor) -> Bool {
        let intensity = getColorIntensity(color)
        return intensity < 0.8 ? false : true
    }
    
    private func getColorIntensity(_ color: UIColor) -> CGFloat {
        guard let convertedColor = color
            .cgColor
            .converted(
                to: CGColorSpaceCreateDeviceRGB(),
                intent: .defaultIntent,
                options: nil
            ),
              let components = convertedColor
            .components else {
            return 0
        }
        let brightness = (
            (components[0] * 299)
            + (components[1] * 587)
            + (components[2] * 114)
        ) / 1000
        return brightness
    }
}

