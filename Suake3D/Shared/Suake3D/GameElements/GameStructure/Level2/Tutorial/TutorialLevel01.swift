//
//  File.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class TutorialLevel01: TutorialLevel {
    
    init(game:GameController) {
        super.init(game: game, levelSize: LevelSize.ExtraSmall, levelName: .GAME_L00_E01, levelGoal: .GAME_L00_E01, levelID: .TUT_01, difficulty: .Tutorial, duration: .Minute_1, wallpaper: .GreenSky, floor: .Space)
    }
}
