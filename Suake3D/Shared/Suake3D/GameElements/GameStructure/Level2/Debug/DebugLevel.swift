//
//  File.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class DebugLevel: SuakeBaseLevel {
    
    init(game:GameController) {
        super.init(game: game, levelSize: LevelSize.Small, levelName: .DBG_std, levelID: .DBG_std, difficulty: LevelDifficulty.Easy, duration: (DbgVars.devMode ? DbgVars.matchDuration : MatchDuration.Infinite), wallpaper: WallpaperType.RandomWallpaper, floor: FloorType.RandomFloor)
        self.levelConfig.loadOppSuake = true
        self.levelConfig.loadDroids = true
        self.levelConfig.loadPortals = true
        self.levelConfig.portalCount = 3
    }
    
}
