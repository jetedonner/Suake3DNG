//
//  ExplodingComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 29.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class ExplodingComponent:GKSCNNodeComponent{
    
    let game:GameController
    var explodeNode:SCNNode = SCNNode()
    
    init(game:GameController) {
        self.game = game
        super.init(node: explodeNode)
    }

    func explode(){

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

