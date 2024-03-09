//
//  ColorsExtension.swift
//  kipi
//
//  Created by Ossi on 01/03/2024.
//

import Foundation
import SwiftUI

extension Color {
    
    /**
     Returns a Color object corresponding to the name given in parameters
     - parameter stringColor: The name of the color
     - returns: The color object
     */
    static func fromString(_ stringColor: String) -> Color {
        switch(stringColor) {
            case "blue": return Color.blue
            case "red": return Color.red
            case "purple": return Color.purple
            case "yellow": return Color.yellow
            case "pink": return Color.pink
            case "orange": return Color.orange
            case "green": return Color.green
            case "black": return Color.black
            default: return Color.primary
        }
    }
    
    
    
    /**
     Returns a optional String value corresponding to the name of the Color object given in parameters
     - parameter color : The color from which we want to know the name
     - returns : The name of the color or nil if the color name doesn't exist
     */
    static func fromColor(_ color: Color) -> String? {
        switch(color) {
            case Color.blue: return "blue"
            case Color.red: return "red"
            case Color.purple: return "purple"
            case Color.yellow: return "yellow"
            case Color.pink: return "pink"
            case Color.orange: return "orange"
            case Color.green: return "green"
            case Color.black: return "black"
            default: return nil
        }
    }
}
