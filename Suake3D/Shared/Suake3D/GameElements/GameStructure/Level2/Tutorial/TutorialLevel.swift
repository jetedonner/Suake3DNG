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

class TutorialLevel: SuakeBaseLevel {
    
    var tutorial:BaseTutorialStep!
    
    init(game: GameController, levelSize:LevelSize, levelName:LevelGoalShort, levelGoal:LevelGoal, levelID:LevelID, difficulty:LevelDifficulty, duration:MatchDuration, wallpaper:WallpaperType, floor:FloorType) {
        
        super.init(game: game, levelSize: levelSize, levelName: levelName, levelID: levelID, difficulty: difficulty, duration: duration, wallpaper: wallpaper, floor: floor)
    }
}
