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

class LevelManager: SuakeGameClass {
    
    var dbgLevel:DebugLevel!
//    var dbgDarkLevel:DebugDarkLevel!
//    var tutorialLevel00:TutorialLevel00!
//    var tutorialLevel01:TutorialLevel01!
//
    var currentLevel:SuakeBaseLevel!
    var levels:[SuakeBaseLevel]!
//
    var gameBoard:GameBoard!
    var distanceManager:DistanceManager!
    
//
    var wallManager:WallManager!
//    var floorManager:FloorManager!
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
        
//
        self.currentLevel = levels.first
//
        self.gameBoard = GameBoard(game: game)
        self.distanceManager = DistanceManager(game: game)
//
        self.wallManager = WallManager(game: game)
        
        
//        self.floorManager = FloorManager(game: game)
//        self.floorManager.setupFloor()
//
        self.lightManager = LightManager(game: game)
        self.lightManager.initLights()
//
//        self.questManager = QuestManager(game: game)
//        self.tutorialManager = TutorialManager(game: game)
    }
    
//    func loadLevel(levelID:LevelID, initialLoad:Bool = false){
//        for level in self.levels{
//            if(level.levelID == levelID){
//                self.currentLevel = level
//                self.loadLevel(initialLoad: initialLoad)
//                break
//            }
//        }
//    }
//
    func loadLevel(initialLoad:Bool = true){
        self.gameBoard.initGameBoard()
        self.currentLevel.loadLevel()
        if(initialLoad){
            self.wallManager.loadWall(initialLoad: initialLoad)
        }
    }
//
//    func loadRandomLevelEnvironment(){
//        self.currentLevel.setRandomWallpaper()
//        self.currentLevel.setRandomFloor()
//    }
//
//    func checkSuakePos(pos:SCNVector3)->Bool{
//        if(pos.x >= (self.currentLevel.levelSize.getNSSize().width / 2) ||
//            pos.x < (self.currentLevel.levelSize.getNSSize().width / -2) ||
//            pos.z >= (self.currentLevel.levelSize.getNSSize().height / 2) ||
//            pos.z < (self.currentLevel.levelSize.getNSSize().height / -2)){
//
//            self.game.showDbgMsg(dbgMsg: DbgMsgs.suakeWallHit, dbgLevel: .InfoOnlyConsole)
//            return false
//        }
//        return true
//    }
//
//    func checkSuakePosWithResult(pos:SCNVector3)->SuakePosResult{
//        if(pos.x >= (self.currentLevel.levelSize.getNSSize().width / 2) ||
//            pos.x < (self.currentLevel.levelSize.getNSSize().width / -2) ||
//            pos.z >= (self.currentLevel.levelSize.getNSSize().height / 2) ||
//            pos.z < (self.currentLevel.levelSize.getNSSize().height / -2)){
//
//            var posRes:SuakePosResult = SuakePosResult()
//            posRes.isInGameBoard = false
//            if(pos.x >= (self.currentLevel.levelSize.getNSSize().width / 2)){
//                posRes.coord = .X
//                posRes.half = .Positive
//                posRes.otherHalf = (pos.z >= 0 ? .Positive : .Negative)
//            }else if(pos.x < (self.currentLevel.levelSize.getNSSize().width / -2)){
//                posRes.coord = .X
//                posRes.half = .Negative
//                posRes.otherHalf = (pos.z >= 0 ? .Positive : .Negative)
//            }else if(pos.z >= (self.currentLevel.levelSize.getNSSize().width / 2)){
//                posRes.coord = .Z
//                posRes.half = .Positive
//                posRes.otherHalf = (pos.x >= 0 ? .Positive : .Negative)
//            }else if(pos.z < (self.currentLevel.levelSize.getNSSize().width / -2)){
//                posRes.coord = .Z
//                posRes.half = .Negative
//                posRes.otherHalf = (pos.x >= 0 ? .Positive : .Negative)
//            }
//            //self.game.showDbgMsg(dbgMsg: DbgMsgs.suakeWallHit)
//            return posRes
//        }
//        return SuakePosResult(isInGameBoard: true, coord: .NONE, half: .NONE)
//    }
}

//struct SuakePosResult{
//    var isInGameBoard:Bool = true
//    var coord:SuakeBoardCoord = .Z
//    var half:SuakeBoardHalf = .Positive
//    var otherHalf:SuakeBoardHalf = .Positive
//}
//
//enum SuakeBoardCoord:String{
//    case X = "X dimension"
//    case Z = "Z dimension"
//    case NONE = "NOT DEFINED dimension"
//}
//
//enum SuakeBoardHalf:String{
//    case Positive = "Positive half"
//    case Negative = "Negative half"
//    case NONE = "NOT DEFINED half"
//}


