//
//  SuakeSpriteNode.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class SuakeSpriteNodeMultiTextures: SuakeSpriteNode {
    
//    var _id:Int = 0
//    var id:Int{
//        get{ return self._id }
//        set{ self._id = newValue }
//    }
//    
//    override var position: CGPoint{
//        get{
//            return super.position
//        }
//        set{
//            super.position = newValue
//        }
//    }
    
    var textures:[SKTexture] = [SKTexture]()
    
    func setTexture(id:Int){
        self.texture = self.textures[id]
    }
    
    init(textures: [SKTexture]) {
        self.init(texture: textures[0])
        self.textures = textures
    }
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
