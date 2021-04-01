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
    //TMP remove before release build
    var testOppSuakeAI:Bool = false
    
    var loadDroids:Bool = false
    var droidsAttackOwn:Bool = false
    var droidsAttackOpp:Bool = false
    
    
    var droidCount:Int = 0
    var loadPortals:Bool = false
    var portalCount:Int = 0
    var loadWeaponPickups:Bool = true
    var showCountdown:Bool = true
    
    override init(game: GameController) {
        super.init(game: game)
    }
}

