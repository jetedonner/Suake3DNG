//
//  RotationAnimHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class RotationAnimHelper {
    
    class func getRotationAnim()->CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = NSValue(scnVector4: SCNVector4(x: CGFloat(0), y: CGFloat(1), z: CGFloat(0), w: CGFloat(Double.pi) * 2))
        animation.duration = 2.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fadeOutDuration = 0.0
        animation.fadeInDuration = 0.0
        animation.repeatCount = MAXFLOAT
        return animation
    }
    
    class func getUpDownAnim()->CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.byValue = 5.0
        animation.autoreverses = true
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fadeOutDuration = 0.0
        animation.fadeInDuration = 0.0
        animation.repeatCount = MAXFLOAT
        return animation
    }
}
