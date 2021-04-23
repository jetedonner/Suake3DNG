//
//  AnimationHelper.swift
//  Suake3D-swift
//
//  Created by dave on 21.02.20.
//  Copyright © 2020 ch.kimhauser. All rights reserved.
//

import Foundation
import SceneKit

class AnimationHelper {

    static func aniColor(from: NSColor, to: NSColor, percentage: CGFloat) -> NSColor {
        let fromComponents = from.cgColor.components!
        let toComponents = to.cgColor.components!
        
        let color = NSColor(red: fromComponents[0] + (toComponents[0] - fromComponents[0]) * percentage,
                            green: fromComponents[1] + (toComponents[1] - fromComponents[1]) * percentage,
                            blue: fromComponents[2] + (toComponents[2] - fromComponents[2]) * percentage,
                            alpha: fromComponents[3] + (toComponents[3] - fromComponents[3]) * percentage)
        return color
    }
}
