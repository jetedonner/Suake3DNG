//
//  BaseHUDComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 28.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class BaseExtHUDComponent: BaseHUDComponent {
    
    var nodeContainer:SKSpriteNode = SKSpriteNode()
    
    var isHidden:Bool{
        get{ return self.node.isHidden }
        set{ self.node.isHidden = newValue }
    }
    
    override init(game:GameController) {
        super.init(game: game, node: self.nodeContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
