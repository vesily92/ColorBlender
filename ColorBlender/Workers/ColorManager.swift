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
    func getStringComponentsOf(
        color: UIColor
    ) -> (red: String, green: String, blue: String)
    func getColorCode(for color: UIColor) -> String
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
    
    func getStringComponentsOf(
        color: UIColor
    ) -> (red: String, green: String, blue: String) {
        let components = getComponentsOf(color: color)
        
        
        let red = String(format: "%.2f", components.red * 255)
        let green = String(format: "%.2f", components.green * 255)
        let blue = String(format: "%.2f", components.blue * 255)
        
        return (red, green, blue)
    }
    
    func getColorCode(for color: UIColor) -> String {
        let components = getComponentsOf(color: color)
        
        return String(
            format: "#%02lX%02lX%02lX", 
            lroundf(Float(components.red * 255)),
            lroundf(Float(components.green * 255)),
            lroundf(Float(components.blue * 255))
        )
    }
    
    private func getColorIntensity(_ color: UIColor) -> CGFloat {
        let components = getComponentsOf(color: color)
        
        let brightness = (
            (components.red * 299)
            + (components.green * 587)
            + (components.blue * 114)
        ) / 1000
        
        return brightness
    }
    
    private func getComponentsOf(
        color: UIColor
    ) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        guard let convertedColor = color
            .cgColor
            .converted(
                to: CGColorSpaceCreateDeviceRGB(),
                intent: .defaultIntent,
                options: nil
            ),
              let components = convertedColor
            .components else {
            return (0, 0, 0)
        }
        
        return (components[0], components[1], components[2])
    }
}

