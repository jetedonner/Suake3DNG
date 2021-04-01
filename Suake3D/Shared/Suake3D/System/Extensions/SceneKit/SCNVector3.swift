//
//  SCNVector3.swift
//  Suake3D
//
//  Created by Kim David Hauser on 29.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit


extension SCNVector3 {
    func distance(to:SCNVector3)->CGFloat{
        return CGFloat((self - to).length())
    }
}
//    func length() -> CGFloat {
//        return CGFloat(sqrtf(Float(x * x + y * y + z * z)))
//    }
//}
//
//extension SCNVector3 : CustomStringConvertible {
//    public var description: String {
//        return "[\(x), \(y), \(z)]"
//    }
//}
//
//func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
//    return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
//}
//
//func + (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
//    return SCNVector3Make(l.x + r.x, l.y + r.y, l.z + r.z)
//}
