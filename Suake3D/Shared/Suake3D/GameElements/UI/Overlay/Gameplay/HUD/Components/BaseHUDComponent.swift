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

class BaseHUDComponent: GKSKNodeComponent {
    
    let game:GameController
    
    init(game:GameController) {
        self.game = game
        super.init()
    }
    
    init(game:GameController, node:SKNode) {
        self.game = game
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
