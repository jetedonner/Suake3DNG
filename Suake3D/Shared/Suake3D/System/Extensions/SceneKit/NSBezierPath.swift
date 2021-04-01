//
//  NSBezierPath.swift
//  Suake3D
//
//  Created by Kim David Hauser on 04.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

extension NSBezierPath {

    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                fatalError()
            }
        }

        return path
    }
}

extension NSBezierPath{
    func addQuadCurve(to endPoint: CGPoint, controlPoint: CGPoint){
        let startPoint = self.currentPoint
        let controlPoint1 = CGPoint(x: (startPoint.x + (controlPoint.x - startPoint.x) * 2.0/3.0), y: (startPoint.y + (controlPoint.y - startPoint.y) * 2.0/3.0))
        let controlPoint2 = CGPoint(x: (endPoint.x + (controlPoint.x - endPoint.x) * 2.0/3.0), y: (endPoint.y + (controlPoint.y - endPoint.y) * 2.0/3.0))
        curve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
}
