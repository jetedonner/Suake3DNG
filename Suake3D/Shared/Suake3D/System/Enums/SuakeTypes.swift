//
//  SuakeTypes.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit

enum SuakePosition : String {
    case OnTheSpot = "On the spot"
    case Front = "Front"
    case Back = "Back"
    case Left = "Left"
    case Right = "Right"
}

class PositionHelper {
    
    static func getPos4DirNPosition(dir:SuakeDir = .UP, relPos:[TurnDir], curPos:SCNVector3)->[SCNVector3]{
        var vectRet:[SCNVector3] = [SCNVector3]()
        for p in relPos{
            let offset:SCNVector3 = self.getPos4DirNPosition(dir: dir, relPos: p)
            var newRelPos:SCNVector3 = curPos
            newRelPos.x += offset.x
            newRelPos.z += offset.z
            vectRet.append(newRelPos)
        }
        return vectRet
    }
    
    static func getPos4DirNPosition(dir:SuakeDir, relPos:[TurnDir])->[SCNVector3]{
        var vectRet:[SCNVector3] = [SCNVector3]()
        for p in relPos{
            vectRet.append(self.getPos4DirNPosition(dir: dir, relPos: p))
        }
        return vectRet
    }
    
    static func getPos4DirNPosition(dir:SuakeDir, relPos:TurnDir)->SCNVector3{
        var vectRet:SCNVector3 = SCNVector3(0,0,0)
        if((dir == .UP && relPos == .Straight) ||
            (dir == .DOWN && relPos == .One80) ||
            (dir == .LEFT && relPos == .Right) ||
            (dir == .RIGHT && relPos == .Left)){
            vectRet.z += 1
        }else if((dir == .UP && relPos == .One80) ||
            (dir == .DOWN && relPos == .Straight) ||
            (dir == .LEFT && relPos == .Left) ||
            (dir == .RIGHT && relPos == .Right)){
            vectRet.z -= 1
        }else if((dir == .UP && relPos == .Left) ||
            (dir == .DOWN && relPos == .Right) ||
            (dir == .LEFT && relPos == .Straight) ||
            (dir == .RIGHT && relPos == .One80)){
            vectRet.x += 1
        }else if((dir == .UP && relPos == .Right) ||
            (dir == .DOWN && relPos == .Left) ||
            (dir == .LEFT && relPos == .One80) ||
            (dir == .RIGHT && relPos == .Straight)){
            vectRet.x -= 1
        }
        return vectRet
    }
    
}

//class PositionHelper {
//
//    static func getPos4DirNPosition(dir:SuakeDir, pos:SuakePosition)->SCNVector3{
//        var vectRet:SCNVector3 = SCNVector3(0,0,0)
//        if((dir == .UP && pos == .Front) ||
//            (dir == .DOWN && pos == .Back) ||
//            (dir == .LEFT && pos == .Right) ||
//            (dir == .RIGHT && pos == .Left)){
//            vectRet.z += 1
//        }else if((dir == .UP && pos == .Back) ||
//            (dir == .DOWN && pos == .Front) ||
//            (dir == .LEFT && pos == .Left) ||
//            (dir == .RIGHT && pos == .Right)){
//            vectRet.z -= 1
//        }else if((dir == .UP && pos == .Left) ||
//            (dir == .DOWN && pos == .Right) ||
//            (dir == .LEFT && pos == .Front) ||
//            (dir == .RIGHT && pos == .Back)){
//            vectRet.x += 1
//        }else if((dir == .UP && pos == .Right) ||
//            (dir == .DOWN && pos == .Left) ||
//            (dir == .LEFT && pos == .Back) ||
//            (dir == .RIGHT && pos == .Front)){
//            vectRet.x -= 1
//        }
//        return vectRet
//    }
//
//}

enum SuakeDir : String, Codable {
    case NONE = "Node"
    case DOWN = "Down"
    case RIGHT = "Right"
    case UP = "Up"
    case LEFT = "Left"
    case PORTATIOM = "Portatiom"
}

extension SuakeDir {
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func decode(data: Data) -> SuakeDir? {
        return try? JSONDecoder().decode(SuakeDir.self, from: data)
    }
}

enum TurnDir : String, Codable{
    case Stop = "Stop"
    case None = "None"
    case Straight = "Straight"
    case Left = "Left"
    case Right = "Right"
    case One80 = "180"
    case Portatiom = "Portatiom"
}

extension TurnDir {
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func decode(data: Data) -> TurnDir? {
        return try? JSONDecoder().decode(TurnDir.self, from: data)
    }
}
