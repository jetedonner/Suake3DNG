//
//  RisingParticles.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class RisingParticlesComponent: SuakeBaseSCNNodeComponent {
    
    init(game: GameController) {
        super.init(game: game, node: SuakeBaseSCNNode(game: game, sceneName: "art.scnassets/particles/RisingParticles.scn"), id: 0)
        self.node.name = "GoodyCatchedParticles"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
