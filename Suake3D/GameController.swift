//
//  GameViewController.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import SceneKit
//import QuartzCore
import GameplayKit
//import MyLibrary
import NetTestFW

class GameController:BaseGameController{
    
    var isLoading:Bool = false
    
    var usrDefHlpr:UserDefaultsHelper!
    var stateMachine:SuakeStateMachine!
    var keyboardHandler:SuakeKeyboardHandler!
    var cameraHelper:CameraHelper!
    var panCameraHelper:PanCameraHelper!
    var dbgHelper:DebugHelper!
    var soundManager:SoundManager!

    var locationEntityManager: LocationEntityManager!
    var playerEntityManager:SuakePlayerManager!
    
    var levelManager:LevelManager!
    var physicsHelper:PhysicsHelper!
    var contactHelper:ContactHelper!
    var overlayManager:OverlayManager!
    
    var gridGraphManager:GridGraphManager!
//    var matchHelper:SuakeMatchHelper!
    var gameCenterHelper:GameCenterHelper!
    
//    var networkHelper:NetworkHelper!
    var networkHelper:NetTestFW.NetworkHelper!
//    var settings:SuakeSettings!
////    var wormHoleHelper:WormHoleHelper!
    ///
    override init(scnView: SCNView) {
        super.init(scnView: scnView)
        
//        var nh:NetTestFW.NetworkHelper = NetTestFW.NetworkHelper()
        self.usrDefHlpr = UserDefaultsHelper(game: self)
//        DbgVars.loadSharedUserDefaults()
        self.gameCenterHelper = GameCenterHelper(game: self)
//        self.gameCenterHelper.viewController = (scnView as! GameViewMacOS).viewController
//        (scnView as! GameViewMacOS).viewController?.registerGameCenterHelper()
        
////        MyLibraryTestClass.sayHello()
//
        self.stateMachine = SuakeStateMachine(game: self)
        self.keyboardHandler = SuakeKeyboardHandler(game: self)
        self.cameraHelper = CameraHelper(game: self)
        self.panCameraHelper = PanCameraHelper(game: self)
        self.dbgHelper = DebugHelper(game: self)
        self.soundManager = SoundManager(game: self)
//        self.audioManager = AudioManager(game: self)
//
        self.locationEntityManager = LocationEntityManager(game: self)
//
//        self.playerEntityManager = PlayerEntityManager(game: self)
        self.playerEntityManager = SuakePlayerManager(game: self)
        self.levelManager = LevelManager(game: self)
        self.physicsHelper = PhysicsHelper(game: self)
        self.contactHelper = ContactHelper(game: self)
        
        self.overlayManager = OverlayManager(game: self)
        
        self.gridGraphManager = GridGraphManager(game: self)
//        self.matchHelper = SuakeMatchHelper(game: self)
        
//        self.networkHelper = NetworkHelper(game: self)
        self.networkHelper = NetTestFW.NetworkHelper()
        
        self.usrDefHlpr.resetUserDefaults2Game()
//
//        self.weaponPickups = WeaponPickupEntityManager(game: self)
//
////        self.wormHoleHelper = WormHoleHelper(game: self)
//
//        self.rulesystemManager = RuleSytemManager(game: self)
//        self.gridGraphManager = GridGraphManager(game: self)
//        self.settings = SuakeSettings()
//
        self.scnView.delegate = self.physicsHelper
        self.scnView.autoenablesDefaultLighting = true
//        self.loadGameScence()
//        self.scnView.cameraControlConfiguration.rotationSensitivity *= self.cameraControlSensitivityFactor
//        self.scnView.cameraControlConfiguration.panSensitivity *= self.cameraControlSensitivityFactor
//        self.scnView.cameraControlConfiguration.truckSensitivity *= self.cameraControlSensitivityFactor

        //self.scnView.cameraControlConfiguration.rotationSensitivity
        scnView.scene?.physicsWorld.contactDelegate = self.contactHelper
//        scnView.scene?.physicsWorld.timeStep = 1 / 360
//        //scnView.scene?.physicsWorld.speed = 2.0
//
//        let testRess:SCNScene = SCNScene(named: "art.scnassets/nodes/weapons/mg/MachinegunBulllet.scn")!
//        self.scnView.prepare([testRess], completionHandler: { success in
//            //print("Prepare of ressources completed successfully! (" + success.description + ")")
//        })
//
//        (scnView as! GameViewMacOS).chMove = self.cameraHelper.panCameraHelper
//
//        self.scnView.prepare([SCNScene(named: "art.scnassets/nodes/medKit/medKit.scn")], completionHandler: {variable in
//            var tmp = -1
//            tmp /= -1
//
//        })
        self.overlayManager.gameLoading.loadScene()
        self.stateMachine.enter(SuakeStateGameLoading.self)
        
        
//        let testObj:PlayerMoveData = PlayerMoveData()
//        testObj.playerId = 123
//        testObj.nextPos = SIMD3<Float>(1, 2, 3)
//        testObj.nextDir = .RIGHT
//        testObj.nextTurnDir = .Right
//
//        let enc:Data = testObj.encode()!
//
//        let retDec:PlayerMoveData = PlayerMoveData.decode(data: enc)! as! PlayerMoveData
//        let retDec2 = retDec
//        self.tryEncDec()
    }
    
    func loadNetworkMatch(levelConfig:LoadLevelNetworkData){
        self.levelManager.currentLevel.loadNetworkMatch(levelConfig: levelConfig)
//        self.levelManager.currentLevel.levelConfigEnv.levelSize = levelConfig.levelConfig.levelEnv.levelSize
//        self.levelManager.currentLevel.levelConfigEnv.skyBoxHelper.setSkybox(type: levelConfig.levelConfig.levelEnv.skyBoxType)
//        self.levelManager.currentLevel.levelConfigEnv.duration = levelConfig.levelConfig.levelEnv.matchDuration
//        self.levelManager.currentLevel.levelConfigEnv.floorHelper.setFloor(type: levelConfig.levelConfig.levelEnv.floorType)
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
        }
    }
    
//    func tryEncDec() {
//        let testObj:TestPlayerMoveData = TestPlayerMoveData()
//        testObj.playerId = 123
//        testObj.playerId2 = 456
//        testObj.nextPos = SIMD3<Float>(1, 2, 3)
//        testObj.nextDir = .RIGHT
//        testObj.nextTurnDir = .Right
//
//        let enc:Data = testObj.encode()!
//
//        print("\(enc)")
//
//        let retDec:TestPlayerMoveData = TestPlayerMoveData.decode(data: enc)!
//        print("\(retDec)")
//        let retDec2 = retDec
//    }
}

//class TestSuakeNetworkData: Codable {
//    
//}
//
//class TestPlayerMoveData: Codable {
//    var playerId:Int = 0
//    var playerId2:Int = 0
////    var players: [Player] = []
////    var time: Int = 60
////    var playerId:Int = 0
//    var nextPos:SIMD3<Float> = SIMD3<Float>(0, 0, 0)
//    var nextTurnDir:TurnDir = .Straight
//    var nextDir:SuakeDir = .UP
//}
//
//extension TestPlayerMoveData {
//    func encode() -> Data? {
//        var retData:Data = try! JSONEncoder().encode(self)
//        return retData
//    }
//    
//    static func decode(data: Data) -> TestPlayerMoveData? {
//        return try? JSONDecoder().decode(TestPlayerMoveData.self, from: data)
//    }
//}
