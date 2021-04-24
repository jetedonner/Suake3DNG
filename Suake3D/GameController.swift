//
//  GameViewController.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import SceneKit
import GameplayKit
import NetTestFW
import GameKit

class GameController:BaseGameController, GameCenterHelperDelegate{
    
    var isLoading:Bool = false
    
    var usrDefHlpr:UserDefaultsHelper!
    var stateMachine:SuakeStateMachine!
    var keyboardHandler:SuakeKeyboardHandler!
    var cameraHelper:CameraHelper!
    var panCameraHelper:PanCameraHelper!
    var dbgHelper:DebugHelper!
    var soundManager:SoundManagerPositional!

    var locationEntityManager: LocationEntityManager!
    var playerEntityManager:SuakePlayerManager!
    
    var levelManager:LevelManager!
    var physicsHelper:PhysicsHelper!
    var contactHelper:ContactHelper!
    var overlayManager:OverlayManager!

    var gridGraphManager:GridGraphManager!
    var gameCenterHelper:GameCenterHelper!
    
    func startMatch(match: GKMatch) {
        self.gameCenterHelper.matchMakerHelper.setMatch(match: match)
        self.stateMachine.enter(stateClass: SuakeStateGameLoadingMulti.self)
    }
    
    override init(scnView: SCNView) {
        super.init(scnView: scnView)

        self.usrDefHlpr = UserDefaultsHelper(game: self)
        self.gameCenterHelper = GameCenterHelper(game: self)
        
        self.stateMachine = SuakeStateMachine(game: self)
        self.keyboardHandler = SuakeKeyboardHandler(game: self)
        self.cameraHelper = CameraHelper(game: self)
        self.panCameraHelper = PanCameraHelper(game: self)
        self.dbgHelper = DebugHelper(game: self)
        self.soundManager = SoundManagerPositional(game: self)
        
        self.locationEntityManager = LocationEntityManager(game: self)
        
        self.playerEntityManager = SuakePlayerManager(game: self)
        self.levelManager = LevelManager(game: self)
        self.physicsHelper = PhysicsHelper(game: self)
        self.contactHelper = ContactHelper(game: self)
        
        self.overlayManager = OverlayManager(game: self)
        
        self.gridGraphManager = GridGraphManager(game: self)
        
        self.usrDefHlpr.resetUserDefaults2Game()
        
        self.scnView.delegate = self.physicsHelper
        self.scnView.autoenablesDefaultLighting = true

        scnView.scene?.physicsWorld.contactDelegate = self.contactHelper

        self.overlayManager.gameLoading.loadScene()
        self.stateMachine.enter(SuakeStateGameLoading.self)
        
    }
    
    var levelLoaded:Bool = false
    var serverLoaded:Bool = false
    
    func loadNetworkMatch(levelConfigNet:LoadLevelNetworkData){
        self.overlayManager.gameCenterOverlay.setProgress(curPrecent: 25, msg: "Loading level for match ...")
        self.levelManager.loadNetworkMatch(levelConfigNet: levelConfigNet)
        self.levelLoaded = true
        
        if(self.levelLoaded && self.serverLoaded && self.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerType == .client){
            self.gameCenterHelper.matchMakerHelper.sendReady4MatchMsg()
        }
    }
    
    func loadNetworkMatch2(setupNet:SetupClientServerNetworkData){
        for host in setupNet.clientServerData {
            print("playerId: " + host.playerId + ", playerType: \(host.playerType), playerNum: \(host.playerNum)")
        }
        self.serverLoaded = true
        if(self.levelLoaded && self.serverLoaded && self.gameCenterHelper.matchMakerHelper.ownPlayerNetObj.playerType == .client){
            self.playerEntityManager.userPlayerSuake = self.playerEntityManager.oppPlayerEntity
            self.gameCenterHelper.matchMakerHelper.sendReady4MatchMsg()
        }
    }
    
    func loadNetworkMatch3(startMatch:StartMatchNetworkData){
        self.stateMachine.enter(SuakeStateMultiplayerPlaying.self)
    }
    
    func pickedUpNetworkMatch(pickedUpData:PickedUpNetworkData){
//        self.playerEntityManager.ownPlayerEntity.shoot()
        if(pickedUpData.itemType == .goody){
//            self.playerEntityManager.goodyEntity.pos = pickedUpData.newPos
            self.playerEntityManager.goodyEntity.reposGoodyAfterCatch(newPos: pickedUpData.newPos)
        }else if(pickedUpData.itemType == .medKit){
//            ((self.locationEntityManager.entityGroups[.MedKit]? as? Set<SuakeNodeGroupBase>)?.first ?.groupItems[pickedUpData.id] as! MedKitEntity).reposMedKitAfterCatch(newPos: pickedUpData.newPos)
            //Kim
        }
    }
    
    func hitByBulletNetworkMatch(hitByBulletData:HitByBulletNetworkData){
//        self.playerEntityManager.ownPlayerEntity.shoot()
        if(hitByBulletData.itemType == .goody){
//            self.playerEntityManager.goodyEntity.pos = pickedUpData.newPos
            self.playerEntityManager.goodyEntity.goodyHitNet(hitByBulletMsg: hitByBulletData)
        }
    }
    
    func shootWeaponNetworkMatch(shootData:ShootWeaponNetworkData){
//        shootData.playerId
        self.playerEntityManager.ownPlayerEntity.weapons.setCurrentWeaponType(weaponType: shootData.weaponType, playAudio: false)
        self.playerEntityManager.ownPlayerEntity.shoot(at: shootData.velocity)
    }
    
    func droidPathNetworkMatch(droidDirData:DroidPathNetworkData){
        self.playerEntityManager.droidEntities[0].droidAIComponent.newPath = droidDirData.path
    }
    
    func turnDirNetworkMatch(turnData:TurnNetworkData){
//        if(turnData.playerId.starts(with: "Droid-")){
//            var droidIdParts:[String.SubSequence] = turnData.playerId.split(separator: "-")
//            let droidId:Int = Int(droidIdParts[1])!
////            self.playerEntityManager.droidEntities[droidId].droidComponent.nextMove(newDir: <#T##SuakeDir#>)
//        }else{
            self.playerEntityManager.ownPlayerEntity.moveComponent.posAfterNetSend = turnData.position
            self.playerEntityManager.ownPlayerEntity.appendTurn(turnDir: turnData.turnDir)
//        }
    }
    
    func droidDirNetworkMatch(droidData:DroidDirNetworkData){
        if(droidData.playerId.starts(with: "Droid-")){
            let droidIdParts:[String.SubSequence] = droidData.playerId.split(separator: "-")
            let droidId:Int = Int(droidIdParts[1])!
            self.playerEntityManager.droidEntities[droidId].droidComponent.nextMove(newDir: droidData.nextDir)
        }//else{
//            self.playerEntityManager.ownPlayerEntity.moveComponent.posAfterNetSend = turnData.position
//            self.playerEntityManager.ownPlayerEntity.appendTurn(turnDir: turnData.turnDir)
//        }
    }
    
    func loadGameScence(initialLoad:Bool = true){
        DispatchQueue.main.async {
            self.isLoading = true
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 5, msg: "Setting up cameras ...")
            self.cameraHelper.initCameras()
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 10, msg: "Setting up levels ...")
            self.levelManager.loadLevel(initialLoad: initialLoad)
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 15, msg: "Setting up players ...")
            self.playerEntityManager.initPlayers()
            self.playerEntityManager.addPlayersToScene()
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 25, msg: "Setting up locations ...")
            self.locationEntityManager.initLocations()
            self.locationEntityManager.addLocationGroupsToScene()
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 35, msg: "Setting up game board ...")
            self.gridGraphManager.loadGridGraph()
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 45, msg: "Setting up HUD ...")
            self.overlayManager.loadScenes()
            self.overlayManager.hud.overlayScene.loadInitialValues()
            self.overlayManager.hud.setupOverlay()
            self.overlayManager.hud.drawHealthBar()
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 100, msg: "Loading finished ...")
            self.scene.isPaused = false
            self.scnView.isPlaying = true
            
            self.stateMachine.enter(SuakeStateReadyToPlay.self)
            if(self.usrDefHlpr.dbgMultiplayer){
                self.dbgMultiplayer()
            }
        }
    }
    
    func dbgMultiplayer(){
        let player2Control:String = self.usrDefHlpr.multiHumanPlayer2Control
        let sendData = LoadLevelNetworkData(id: 689)
        self.loadNetworkMatch(levelConfigNet: sendData)
        if(player2Control == "Player 2"){
            self.cameraHelper.toggleFPVOpp(newFPV: false)
        }
        self.overlayManager.hud.msgComponent.showMsgFadeAndScale2Big(msg: "You are \(player2Control)", duration: 3.0, completionHandler: {

        })
    }
    
    override func quitSuake3D(){
        super.quitSuake3D()
        if(self.gameCenterHelper.isMultiplayerGameRunning){
            self.gameCenterHelper.matchMakerHelper.match.disconnect()
        }
    }
}
