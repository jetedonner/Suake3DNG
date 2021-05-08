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
import MetalKit
//import GPUImage
//import CoreImage
//import OpenGL
//import QuartzCore
//import GLKit

class GameController:BaseGameController, GameCenterHelperDelegate{
    
    var isLoading:Bool = false
    
    // Multiplayer vars
    var levelLoaded:Bool = false
    var serverLoaded:Bool = false
    
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
    
    var rndrr:SCNRenderer!// = SCNRenderer()
    
    func startMatch(match: GKMatch) {
        self.gameCenterHelper.matchMakerHelper.setMatch(match: match)
        self.stateMachine.enter(stateClass: SuakeStateGameLoadingMulti.self)
    }
    
//    var tvMonEnt:[TVMonitorEntity] = [TVMonitorEntity]()
    var tvMonitorManager:TVMonitorManager!
    
    // EAGLContext in the sharegroup with GPUImage
//    var eaglContext: EAGLContext!
    
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
        self.tvMonitorManager = TVMonitorManager(game: self)
        
        self.playerEntityManager = SuakePlayerManager(game: self)
        self.levelManager = LevelManager(game: self)
        self.physicsHelper = PhysicsHelper(game: self)
        self.contactHelper = ContactHelper(game: self)
        
        self.overlayManager = OverlayManager(game: self)
        
        self.gridGraphManager = GridGraphManager(game: self)
        
        self.usrDefHlpr.resetUserDefaults2Game()
//        SCNRenderer
//        guard let mtlDevice = MTLCreateSystemDefaultDevice() else {
//            print("Error creating mtl device")
//            return
//        }
        
//        scnRenderer = SCNRenderer(device: mtlDevice, options: nil)
//        scnRenderer?.scene = sceneView.scene
//        let renderer = SCNRenderer( context: EAGLContext.currentContext(), options: nil )
//        self.rndrr = SCNRenderer(context: <#T##CGLContextObj?#>, options: <#T##[AnyHashable : Any]?#>) (device: mtlDevice, options: nil)
        self.rndrr = SCNRenderer(device: MTLCreateSystemDefaultDevice(), options: nil)
//        renderer!.scene = hiddenScene
        self.rndrr.scene = self.scnView.scene
        self.rndrr.pointOfView = self.cameraHelper.cameraNodeFP
        self.scnView.delegate = self.physicsHelper
        self.scnView.autoenablesDefaultLighting = true
//        self.scnView.debugOptions = [.showPhysicsShapes]

        scnView.scene?.physicsWorld.contactDelegate = self.contactHelper

        self.overlayManager.gameLoading.loadScene()
        self.stateMachine.enter(SuakeStateGameLoading.self)
        
    }
    
    func loadGameScence(initialLoad:Bool = true){
        DispatchQueue.main.async {
            self.isLoading = true
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 5, msg: "Setting up cameras ...")
            self.cameraHelper.initCameras()
//            self.tvNode.geometry?.firstMaterial?.diffuse.contents = self.cameraHelper.cameraNodeFP.camera
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 10, msg: "Setting up levels ...")
            self.levelManager.loadLevel(initialLoad: initialLoad)
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 15, msg: "Setting up players ...")
            self.playerEntityManager.initPlayers()
            self.playerEntityManager.addPlayersToScene()
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 25, msg: "Setting up locations ...")
            self.locationEntityManager.initLocations()
            self.locationEntityManager.addLocationGroupsToScene()
            
            self.locationEntityManager.addPortalEntities(numberOfPortals: 3)
            
//            self.tvMonEnt.append(TVMonitorEntity(game: self, id: 0))
//            self.tvMonEnt.append(TVMonitorEntity(game: self, id: 1))
//            self.tvMonEnt.append(TVMonitorEntity(game: self, id: 2))
//            self.tvMonEnt.append(TVMonitorEntity(game: self, id: 3))
//            self.tvMonEnt[0].showTVMonitor(pos: SCNVector3(0, 1, 10))
//            self.tvMonEnt[1].showTVMonitor(pos: SCNVector3(0, 1, -10))
//            self.tvMonEnt[2].showTVMonitor(pos: SCNVector3(10, 1, 0))
//            self.tvMonEnt[3].showTVMonitor(pos: SCNVector3(-10, 1, 0))
            
            
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 35, msg: "Setting up game board ...")
            self.gridGraphManager.loadGridGraph()
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 45, msg: "Setting up HUD ...")
            self.overlayManager.loadScenes()
            self.overlayManager.hud.overlayScene.loadInitialValues()
            self.overlayManager.hud.setupOverlay()
            self.overlayManager.hud.drawHealthBar()
            
//            self.locationEntityManager.addLocationToScene(pos: SCNVector3(0, 0, 2))
            
            self.overlayManager.gameLoading.setProgress(curPrecent: 100, msg: "Loading finished ...")
            self.scene.isPaused = false
            self.scnView.isPlaying = true
            
            self.stateMachine.enter(SuakeStateReadyToPlay.self)
            
//            self.tvMonitorManager.startTVMonitorUpdate()
            if(self.usrDefHlpr.dbgMultiplayer){
                self.dbgMultiplayer()
            }
        }
    }
    
//    func startTVMonitorUpdate(){
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (1.0 * 0.024), execute: {
//            let newScnView = self.overlayView
//            newScnView.pointOfView = self.cameraHelper.cameraNodeFP
//            let screenshot:NSImage = newScnView.snapshot().imageRotatedByDegreess(degrees: CGFloat(-90))
////                print("TV-UpdateTime: \(time)")
//            self.tvMonitorManager.tvMonEnt[0].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = screenshot
//            self.tvMonitorManager.tvMonEnt[1].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = screenshot
//            self.tvMonitorManager.tvMonEnt[2].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = screenshot
//            self.tvMonitorManager.tvMonEnt[3].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = screenshot
//            self.startTVMonitorUpdate()
//        })
////        if(self.deltaTime.truncatingRemainder(dividingBy: 0.25) == 0){
////            DispatchQueue.main.async {
////
////            }
////        }
//    }
    
    func dbgMultiplayer(){
        let player2Control:String = self.usrDefHlpr.multiHumanPlayer2Control
        let sendData = LoadLevelNetworkData(id: 689)
        self.multiplayerLoad(levelConfigNet: sendData)
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
