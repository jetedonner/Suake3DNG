//
//  CGPointExtension.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit

extension NSSize : ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self = NSSize.convertFromStringLiteral(value: value)
    }
    
    static func convertFromStringLiteral(value: String) -> NSSize {
        return NSSizeFromString(value) // CGPointFromString on iOS
    }

    static func convertFromExtendedGraphemeClusterLiteral(value: String) -> NSSize {
        return NSSizeFromString(value) // CGPointFromString on iOS
    }
}
