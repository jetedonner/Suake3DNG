//
//  VertexArray.swift
//  Suake3D
//
//  Created by dave on 25.04.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

struct VertexArray {
    var array: [Float3] = []
    var continuesInX: Bool
    var continuesInY: Bool
    let width: Int
    let height: Int
    init(width: Int, height: Int) {
        self.continuesInX = false
        self.continuesInY = false
        self.width = width
        self.height = height
        self.array = []
        
        for _ in (0..<height) {
            for _ in (0..<width) {
                array += [Float3(x: 0, y: 0, z: 0)]
            }
        }
    }
    func getVertexIndex(x: Int, _ y: Int) -> Int {
        return y *  width + x
    }
    func getVertexIndexCInt(x: Int, _ y: Int) -> CInt {
        return CInt(getVertexIndex(x: x, y))
    }
    func getVertex(x: Int, _ y: Int) -> Float3 {
        return array[getVertexIndex(x: x, y)]
    }
    func getAdjacentVertex(x: Int, y: Int, from direction: Direction) -> Float3? {
        let coordinate = getAdjacentVertexCoordinate(x: x, y: y, from: direction)
        
        if coordinate.0 >= 0 &&
            coordinate.0 < width &&
            coordinate.1 >= 0 &&
            coordinate.1 < height {
            return getVertex(x: coordinate.0, coordinate.1)
        }
        return nil
    }
    func getAdjacentVertexCoordinate(x: Int, y: Int, from direction: Direction) -> (Int, Int) {
        let modifierX = (direction == .East) ? 1 : (direction == .West) ? -1 : 0
        let modifierY = (direction == .North) ? -1 : (direction == .South) ? 1 : 0
        
        var coordinateX = x + modifierX
        var coordinateY = y + modifierY
        if continuesInX {
            coordinateX %= width
            if coordinateX == -1 {
                coordinateX = width - 1
            }
        }
        if continuesInY {
            coordinateY %= height
            if coordinateY == -1 {
                coordinateY = height - 1
            }
        }
        return (coordinateX, coordinateY)
    }
    func getAdjacentVertexIndex(x: Int, y: Int, from direction: Direction) -> Int {
        let coordinate = getAdjacentVertexCoordinate(x: x, y: y, from: direction)
        return coordinate.1 * width + coordinate.0
    }
    func getAdjacentVertexIndexCInt(x: Int, y: Int, from direction: Direction) -> CInt {
        return CInt(getAdjacentVertexIndex(x: x, y: y, from: direction))
    }
    func getCrossProduct(x: Int, y: Int, from planarDirection: PlanarDirection) -> Float3? {
        let u = getAdjacentVertex(x: x, y: y, from: planarDirection.cardinalDirections.0)
        let v = getAdjacentVertex(x: x, y: y, from: planarDirection.cardinalDirections.1)
        
        if let vNotNil = v {
            if let uNotNil = u {
                let from = getVertex(x: x, y)
                let toU = uNotNil.subtract(subtrahend: from)
                let toV = vNotNil.subtract(subtrahend: from)
                if continuesInX {
                    return toV.crossProductWith(v: toU)
                }
                return toU.crossProductWith(v: toV)
            }
        }
        return nil
    }
    func getNormal(x: Int, y: Int) -> Float3 {
        let crossNorthWest = getCrossProduct(x: x, y: y, from: .NorthWest)
        let crossNorthEast = getCrossProduct(x: x, y: y, from: .NorthEast)
        let crossSouthEast = getCrossProduct(x: x, y: y, from: .SouthEast)
        let crossSouthWest = getCrossProduct(x: x, y: y, from: .SouthWest)
        //println("(\(x), \(y)) -> crossNorthWest: \(crossNorthWest); crossNorthEast: \(crossNorthEast); crossSouthEast: \(crossSouthEast); crossSouthWest: \(crossSouthWest); ")
        let sum = Float3(x: 0, y: 0, z: 0).add(to: crossNorthWest).add(to: crossNorthEast).add(to: crossSouthEast).add(to: crossSouthWest)
        
        return sum.normalize()
    }
    mutating func setVertex(vertex: Float3, x: Int, y: Int) {
        array[getVertexIndex(x: x, y)] = vertex
    }
}
