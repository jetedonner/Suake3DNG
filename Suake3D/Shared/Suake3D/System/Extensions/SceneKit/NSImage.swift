//
//  NSImage.swift
//  Suake3D
//
//  Created by Kim David Hauser on 03.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

//import os
import AppKit
import Foundation
import SceneKit

extension NSSound.Name {
    static let change = NSSound.Name("change")
}

extension NSImage.Name {
    static let red = NSImage.Name("red")
    static let punkt = NSImage.Name("punkt")
    static let wall = NSImage.Name("wall1")
    static let wallHalf = NSImage.Name("wallHalfWidth")
    static let lava = NSImage.Name("lava")
    static let greenPlasma = NSImage.Name("greenPlasma")
    static let greenPlasma2 = NSImage.Name("greenPlasma2")
    static let wallpaper = NSImage.Name("redGalaxy")
    static let wallpapers:[NSImage.Name] = [NSImage.Name("redGalaxy"),NSImage.Name("pinkSunrise"),NSImage.Name("greenSky"),NSImage.Name("greenSea"),NSImage.Name("clearSky"),NSImage.Name("blueMoon")]
}

extension NSImage {
    func inverted() -> NSImage {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("Could not create CGImage from NSImage")
            return self
        }

        let ciImage = CIImage(cgImage: cgImage)
        guard let filter = CIFilter(name: "CIColorInvert") else {
            print("Could not create CIColorInvert filter")
            return self
        }

        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else {
            print("Could not obtain output CIImage from filter")
            return self
        }

        guard let outputCgImage = outputImage.toCGImage() else {
            print("Could not create CGImage from CIImage")
            return self
        }

        return NSImage(cgImage: outputCgImage, size: self.size)
    }
}

fileprivate extension CIImage {
    func toCGImage() -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(self, from: self.extent) {
            return cgImage
        }
        return nil
    }
}

public extension NSImage {
    func imageRotatedByDegreess(degrees:CGFloat) -> NSImage {

    var imageBounds = NSZeroRect ; imageBounds.size = self.size
    let pathBounds = NSBezierPath(rect: imageBounds)
    var transform = NSAffineTransform()
    transform.rotate(byDegrees: degrees)
    pathBounds.transform(using: transform as AffineTransform)
    let rotatedBounds:NSRect = NSMakeRect(NSZeroPoint.x, NSZeroPoint.y, pathBounds.bounds.size.width, pathBounds.bounds.size.height )
    let rotatedImage = NSImage(size: rotatedBounds.size)

    //Center the image within the rotated bounds
    imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth(imageBounds) / 2)
    imageBounds.origin.y  = NSMidY(rotatedBounds) - (NSHeight(imageBounds) / 2)

    // Start a new transform
    transform = NSAffineTransform()
    // Move coordinate system to the center (since we want to rotate around the center)
    transform.translateX(by: +(NSWidth(rotatedBounds) / 2 ), yBy: +(NSHeight(rotatedBounds) / 2))
    transform.rotate(byDegrees: degrees)
    // Move the coordinate system bak to normal
    transform.translateX(by: -(NSWidth(rotatedBounds) / 2 ), yBy: -(NSHeight(rotatedBounds) / 2))
    // Draw the original image, rotated, into the new image
    rotatedImage.lockFocus()
    transform.concat()
    self.draw(in: imageBounds, from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1.0)
    rotatedImage.unlockFocus()

    return rotatedImage
    }
}
