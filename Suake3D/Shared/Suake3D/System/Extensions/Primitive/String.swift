//
//  String.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import GameplayKit
import SceneKit

extension String{
    
    init(withInt int: Int, leadingZeros: Int = 2) {
        self.init(format: "%0\(leadingZeros)d", int)
    }
    
    func subString(from:Index)->String{
        return String(self[from...])
    }

    func leadingZeros(_ zeros: Int) -> String {
        if let int = Int(self) {
            return String(withInt: int, leadingZeros: zeros)
        }
        print("Warning: \(self) is not an Int")
        return ""
    }
}

extension Range where Bound == String.Index {
    func asNSRange(str:String) -> NSRange {
        let location = self.lowerBound.utf16Offset(in: str)
        let length = self.lowerBound.utf16Offset(in: str) - self.upperBound.utf16Offset(in: str)
        return NSRange(location: location, length: length)
    }
}

extension String {
    
    func asStylizedPrice() -> NSMutableAttributedString {
        return self.asStylizedPrice(using: NSFont(name: "DpQuake", size: 32.0)!)
    }
    
    func asStylizedPrice(using font: NSFont, color:NSColor = .white) -> NSMutableAttributedString {
        let rngAll:NSRange = NSRange(location: 0, length: self.count)
        let stylizedPrice = NSMutableAttributedString(string: self, attributes: [.font: font])

        guard var changeRange = self.range(of: "/")?.asNSRange(str: self) else {
            return stylizedPrice
        }

        changeRange.length = self.count - changeRange.location
        // forgive the force unwrapping
        let changeFont = NSFont(name: font.fontName, size: (font.pointSize / 2))!
        let offset = font.capHeight - changeFont.capHeight
        stylizedPrice.addAttribute(.foregroundColor, value: color, range: rngAll)
        stylizedPrice.addAttribute(.font, value: changeFont, range: changeRange)
        stylizedPrice.addAttribute(.baselineOffset, value: offset, range: changeRange)
        return stylizedPrice
    }
    
    func asStylizedDegrees() -> NSMutableAttributedString {
        return self.asStylizedDegrees(using: NSFont(name: "DpQuake", size: 32.0)!)
    }
    
    func asStylizedDegrees(using font: NSFont) -> NSMutableAttributedString {
        let rngAll:NSRange = NSRange(location: 0, length: self.count)
        let stylizedDegrees = NSMutableAttributedString(string: self, attributes: [.font: font])

        guard var changeRange = self.range(of: " ")?.asNSRange(str: self) else {
            return stylizedDegrees
        }

        changeRange.length = self.count - changeRange.location
        // forgive the force unwrapping
        let changeFont = NSFont(name: font.fontName, size: (font.pointSize * 4))!
//        let offset = font.capHeight - changeFont.capHeight
        stylizedDegrees.addAttribute(.foregroundColor, value: NSColor.white, range: rngAll)
        stylizedDegrees.addAttribute(.font, value: changeFont, range: changeRange)
        //stylizedDegrees.addAttribute(.baselineOffset, value: -offset * 3, range: changeRange)
        return stylizedDegrees
    }
}
