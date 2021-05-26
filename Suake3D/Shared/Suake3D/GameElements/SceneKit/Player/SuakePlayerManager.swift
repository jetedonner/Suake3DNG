//
//  SuakePlayerManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 12.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class SuakePlayerManager: SuakeGameClass {
    
    
    var multiHumanPlayers:[SuakeMultiplayerPlayerEntity] = [SuakeMultiplayerPlayerEntity]()
    
    var ownPlayerEntity:SuakeOwnPlayerEntity!
    var oppPlayerEntity:SuakeOppPlayerEntity!
    
    var goodyEntity:GoodyEntity!
    var droidEntities:[DroidEntity] = [DroidEntity]()
    
    var _userPlayerSuake:SuakePlayerEntity!
    var userPlayerSuake:SuakePlayerEntity{
        get{ return self._userPlayerSuake }
        set{
            self._userPlayerSuake = newValue
//            self.userPlayerSuake.cameraComponent
        }
    }
    
    var droidsNotDead:[DroidEntity]{
        get{
            return self.droidEntities.filter {$0.died == false}
        }
    }
    
    var isPaused:Bool{
        get{ return self.ownPlayerEntity.isPaused }
        set{ self.ownPlayerEntity.isPaused = newValue }
    }
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func initPlayers(){
        self.goodyEntity = GoodyEntity(game: self.game)
        self.goodyEntity.goodyComponent.initSetupPos()
        
        self.ownPlayerEntity = SuakeOwnPlayerEntity(game: self.game)
        if(self.game.levelManager.currentLevel.levelConfig.levelSetup.loadAISuake){
            self.oppPlayerEntity = SuakeOppPlayerEntity(game: self.game)
        }
        
        self.userPlayerSuake = self.ownPlayerEntity
        
        
        
        if(self.game.usrDefHlpr.loadDroids){
            let droid:DroidEntity = DroidEntity(game: self.game, id: 0)
            droid.droidComponent.initSetupPos()
            self.droidEntities.append(droid)
        }
    }
    
    func addPlayersToScene(){
        self.ownPlayerEntity.setupPlayerEntity()
        if(self.game.levelManager.currentLevel.levelConfig.levelSetup.loadAISuake){
            self.oppPlayerEntity.setupPlayerEntity()
        }
        self.goodyEntity.add2Scene()
        
        for droid in self.droidEntities{
            droid.add2Scene()
        }
    }
    
    func resetPlayerEntities(){
        self.ownPlayerEntity.resetPlayerEntity()
        if(self.game.levelManager.currentLevel.levelConfig.levelSetup.loadAISuake){
            self.oppPlayerEntity.resetPlayerEntity()
        }
        self.goodyEntity.resetPlayerEntity()
    }
}
