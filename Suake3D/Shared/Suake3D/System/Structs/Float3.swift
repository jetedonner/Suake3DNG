//
//  Float3.swift
//  Suake3D
//
//  Created by dave on 25.04.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

struct Float3: /*Printable,*/ Equatable {
    var x, y, z: GLfloat
    var description: String {
        return "Float3(\(x), \(y), \(z))"
    }
    func factor(factor: GLfloat) -> Float3 {
        let tempX = x * factor
        let tempY = y * factor
        let tempZ = z * factor
        
        return Float3(x: tempX, y: tempY, z: tempZ)
    }
    func add(to: Float3) -> Float3 {
        return Float3(x: x + to.x, y: y + to.y, z: z + to.z)
    }
    func add(to: Float3?) -> Float3 {
        if let toNotNil = to {
            return Float3(x: x + toNotNil.x, y: y + toNotNil.y, z: z + toNotNil.z)
        }
        return Float3(x: x, y: y, z: z)
    }
    func subtract(subtrahend: Float3) -> Float3 {
        return Float3(x: x - subtrahend.x, y: y - subtrahend.y, z: z - subtrahend.z)
    }
    func normalize() -> Float3 {
        let length = sqrt(x*x + y*y + z*z)
        if length != 0 {
            return Float3(x: x/length, y: y/length, z: z/length)
        }
        return Float3(x: 0, y: 0, z: 0)
    }
    func crossProductWith(v: Float3) -> Float3 {
        let xCross = y*v.z - z*v.y
        let yCross = z*v.x - x*v.z
        let zCross = x*v.y - y*v.x
        
        return Float3(x: xCross, y: yCross, z: zCross)
    }
}
// Operator overload
func ==(lhs: Float3, rhs: Float3) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}
