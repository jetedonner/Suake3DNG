//
//  LevelManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit
import NetTestFW

class LevelManager: SuakeGameClass {
    
    var dbgLevel:DebugLevel!
    var currentLevel:SuakeBaseLevel!
    var levels:[SuakeBaseLevel]!
    
    var gameBoard:GameBoard!
    var distanceManager:DistanceManager!
    var wallManager:WallManager!
    var lightManager:LightManager!
//
//    var questManager:QuestManager!
//    var tutorialManager:TutorialManager!
    
    override init(game: GameController) {
        super.init(game: game)
        
        self.dbgLevel = DebugLevel(game: game)
//        self.dbgDarkLevel = DebugDarkLevel(game: game)
//
//        self.tutorialLevel00 = TutorialLevel00(game: game)
//        self.tutorialLevel01 = TutorialLevel01(game: game)
//
//        levels = [self.dbgLevel, self.dbgDarkLevel, self.tutorialLevel00, self.tutorialLevel01]
        levels = [self.dbgLevel]
        
        self.currentLevel = levels.first
        self.gameBoard = GameBoard(game: game)
        self.distanceManager = DistanceManager(game: game)
        self.wallManager = WallManager(game: game)
        
        self.lightManager = LightManager(game: game)
        self.lightManager.initLights()
    }
    
    func loadLevel(initialLoad:Bool = true){
        self.gameBoard.initGameBoard()
        self.currentLevel.loadLevel()
        self.lightManager.setAmbientLight(intensity: self.currentLevel.levelConfigEnv.lightIntensity)
        if(initialLoad){
            self.wallManager.loadWall(initialLoad: initialLoad)
        }
    }
    
    func loadNetworkMatch(levelConfigNet:LoadLevelNetworkData){
        let multiplayerLevel:MultiplayerLevel = MultiplayerLevel(game: self.game, levelConfigNet: levelConfigNet)
        self.currentLevel = multiplayerLevel
        self.loadLevel(initialLoad: true)
        
    }
}

