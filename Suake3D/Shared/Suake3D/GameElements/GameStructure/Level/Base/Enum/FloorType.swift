//
//  FloorType.swift
//  Suake3D
//
//  Created by Kim David Hauser on 17.03.21.
//

import Foundation

enum FloorType:String {
    case Sand = "art.scnassets/textures/floors/desert_sand_floor_512x512.png"
    case Grass = "art.scnassets/textures/floors/grass_floor_512x512.png"
    case Space = "art.scnassets/textures/floors/space_glowing_plate_floor_512x512.png"
    case Stone = "art.scnassets/textures/floors/stone_floor_512x512.png"
    case Debug = "art.scnassets/textures/floors/stone_floor_512x512_DBG.png"
    
    case Bricks = "art.scnassets/textures/floors/floorPanelBricksLowPoly_512x512.png"
    case GreenMotherboard = "art.scnassets/textures/floors/floorPanelGreenMotherboard_512x512.png"
    case Metalic = "art.scnassets/textures/floors/floorPanelMetalic_512x512.png"
    case Patina = "art.scnassets/textures/floors/floorPanelMetalPatina_512x512.png"
    
    case RandomFloor = "A random floor texture"
    
    static var allFloors: [FloorType] {
        return [.Sand, .Grass, .Space, .Stone, .Debug, .Bricks, .GreenMotherboard, .Metalic, .Patina]
    }
    
    static func random() -> FloorType {
        let randomIndex = Int(arc4random()) % self.allFloors.count
        return self.allFloors[randomIndex]
    }
}
