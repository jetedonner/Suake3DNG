//
//  Colors.swift
//  Suake3D
//
//  Created by dave on 18.04.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

extension NSColor{
    internal static let suake3DRed:NSColor = NSColor(named: "Suake3DRed")!
    internal static let suake3DOppBlue:NSColor = NSColor(named: "Suake3DOpponentBlue")!
    internal static let suake3DTextColor:NSColor = NSColor(named: "Suake3DTextColor")!
}

extension NSColor {
    static func addColor(_ color1: NSColor, with color2: NSColor) -> NSColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // add the components, but don't let them go above 1.0
        return NSColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }

    static func multiplyColor(_ color: NSColor, by multiplier: CGFloat) -> NSColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return NSColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
    }


    static func +(color1: NSColor, color2: NSColor) -> NSColor {
        return addColor(color1, with: color2)
    }

    static func *(color: NSColor, multiplier: Double) -> NSColor {
        return multiplyColor(color, by: CGFloat(multiplier))
    }
}
