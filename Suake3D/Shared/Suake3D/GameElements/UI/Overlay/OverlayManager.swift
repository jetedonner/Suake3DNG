//
//  OverlayManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 13.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class OverlayManager: SuakeGameClass {
    
    let gameLoading:GameLoadingSkScene
    let hud:HUDOverlayEntity
    let paused:GamePaused
    let matchOver:MatchOver
    let matchResults:MatchResultsSkScene
    let mainMenu:MenuSkScene
    
    let gameCenterOverlay:GameCenterSkScene
    
    var allOverlays:[SuakeBaseOverlay]!
    var currentOverlay:SuakeBaseOverlay!
    
    override init(game: GameController) {
        self.gameLoading = GameLoadingSkScene(game: game)
        self.hud = HUDOverlayEntity(game: game)
        self.paused = GamePaused(game: game)
        self.matchOver = MatchOver(game: game)
        self.matchResults = MatchResultsSkScene(game: game)
        self.mainMenu = MenuSkScene(game: game)
        
        self.gameCenterOverlay = GameCenterSkScene(game: game)
        
        super.init(game: game)
        
        self.allOverlays = [self.hud.overlayScene, self.paused, self.matchOver, self.matchResults, self.mainMenu, self.gameCenterOverlay]
    }
    
    func overlay4GameState(type:OverlayType)->SuakeBaseOverlay?{
        if(type == .loading){
            return self.gameLoading
        }else if(type == .playing){
            return self.hud.overlayScene
        }else if(type == .menu){
            return self.mainMenu
        }/*else if(type == .menuSetupMain){
            return self.setupMain
        }else if(type == .menuSetupDeveloper){
            return self.setupDeveloper
        }*/else if(type == .ready2Play){
            return self.hud.overlayScene
        }else if(type == .gameCenter){
                return self.gameCenterOverlay
                
        }/*else if(type == .tutorialMode){
            return self.tutorialOverlay
        }else if(type == .tutorialStepCompleted){
            return self.tutorialCompletedOverlay
        }*/else if(type == .matchOver){
            return self.matchOver
        }else if(type == .matchResult){
            return self.matchResults
        }else if(type == .paused){
            return self.paused
        }/*else if(type == .nukeView){
            return self.nukeView
        }else if(type == .cheatsheet){
            return self.cheatsheet
        }*/else{
            return self.hud.overlayScene
        }
    }
    
    func loadScenes(){
        self.paused.loadScene()
        self.matchOver.loadScene()
        self.gameCenterOverlay.loadScene()
//        self.gameLoading.loadScene()
//        self.matchResult.lo
        self.mainMenu.loadScene()
    }
    
    func showOverlay4GameState(type:OverlayType){
        self.setOverlaySKScene(overlay: self.overlay4GameState(type: type)!)
        if(type == .loading || type == .matchOver || type == .matchResult || type == .menu || type == .tutorialMode || type == .tutorialStepCompleted || type == .paused || type == .menuSetupMain || type == .menuSetupDeveloper  || type == .cheatsheet){
            self.game.cameraHelper.blurVision(blurOn: .BlurOn)
        }else{
            self.game.cameraHelper.blurVision(blurOn: .BlurOff)
        }
    }
    
    func setOverlaySKScene(overlay:SuakeBaseOverlay){
        self.currentOverlay = overlay
        self.game.scnView.overlaySKScene = overlay.sceneNode
//        overlay.sceneNode.isPaused = false
        overlay.showOverlayScene()
//        overlay.isPaused = false
    }
    
    func mouseDownHandler(in view: NSView, with event: NSEvent) -> Bool {
        if(self.game.stateMachine.currentState is SuakeStateMainMenu /*||
            self.game.stateMachine.currentState is SuakeStateMainSetup ||
            self.game.stateMachine.currentState is SuakeStateTutorial ||
            self.game.stateMachine.currentState is SuakeStateTutorialCompleted*/){
            guard (self.currentOverlay != nil) else {
                return true
            }
            return self.currentOverlay.mouseDownHandler(in: view, with: event)
        }
        return true
    }
}
