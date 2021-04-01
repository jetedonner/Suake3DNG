//
//  LevelConfiguration.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class LevelConfiguration: SuakeGameClass {
    
    var loadOppSuake:Bool = false
    var loadDroids:Bool = false
    var loadAmbientLight:Bool = false
    var loadPortals:Bool = true
    var portalCount:Int = 1
    
    override init(game: GameController) {
        super.init(game: game)
    }
}

