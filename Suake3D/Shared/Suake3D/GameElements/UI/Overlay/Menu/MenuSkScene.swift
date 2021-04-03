//
//  CreditsSkScene.swift
//  Suake3D
//
//  Created by dave on 01.08.18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import GameKit

class MenuSkScene:SuakeBaseOverlay, GameCenterHelperDelegate {
    
    var selMenuItem:SKNode!
    var menuCursor:MenuCursor!
    
    public var lblInd:SKLabelNode! = nil
    public var lblIndBG:SKLabelNode! = nil
    public var lblMultiPlayer:SKLabelNode! = nil
    public var lblMultiPlayerBG:SKLabelNode! = nil
    public var lblSinglePlayer:SKLabelNode! = nil
    public var lblSinglePlayerBG:SKLabelNode! = nil
    public var lblSettings:SKLabelNode! = nil
    public var lblSettingsBG:SKLabelNode! = nil
    public var lblCredits:SKLabelNode! = nil
    public var lblCreditsBG:SKLabelNode! = nil
    public var lblExit:SKLabelNode! = nil
    public var lblExitBG:SKLabelNode! = nil
    
    public var lblContinueGame:SKLabelNode! = nil
    public var lblContinueGameBG:SKLabelNode! = nil
    
    public var lblHighscore:SKLabelNode! = nil
    public var lblHighscoreBG:SKLabelNode! = nil

    public var menuPos:Int = 0
    
    var indBasePos:CGFloat = 0.0
    var indBGBasePos:CGFloat = 0.0
    
    var isShowing:Bool = false
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    convenience init(game:GameController) {
        self.init(size: (game.scnView.window?.frame.size)!)
        
        self.game = game
        self.menuCursor = MenuCursor(game: game)
    }
    
    func loadScene(){
        if let sceneNode = SKScene.init(fileNamed: "art.scnassets/overlays/menu/Menu") {
            self.sceneNode = sceneNode
            if let view = self.view {
                view.presentScene(sceneNode) //present the scene.
            }
        }
        lblInd = self.sceneNode.childNode(withName: "lblIndicator") as? SKLabelNode
        indBasePos = lblInd.position.y
        
        lblIndBG = self.sceneNode.childNode(withName: "lblIndicatorBG") as? SKLabelNode
        indBGBasePos = lblIndBG.position.y
        
        lblMultiPlayer = self.sceneNode.childNode(withName: "lblMultiPlayer") as? SKLabelNode
        lblMultiPlayerBG = self.sceneNode.childNode(withName: "lblMultiPlayerBG") as? SKLabelNode
        lblMultiPlayerBG.fontColor = NSColor.black
        
        lblSinglePlayer = self.sceneNode.childNode(withName: "lblSinglePlayer") as? SKLabelNode
        lblSinglePlayerBG = self.sceneNode.childNode(withName: "lblSinglePlayerBG") as? SKLabelNode
        lblSinglePlayerBG.fontColor = NSColor.yellow
        
        lblSettings = self.sceneNode.childNode(withName: "lblSetup") as? SKLabelNode
        lblSettingsBG = self.sceneNode.childNode(withName: "lblSetupBG") as? SKLabelNode
        lblSettingsBG.fontColor = NSColor.black
        
        lblCredits = self.sceneNode.childNode(withName: "lblCredits") as? SKLabelNode
        lblCreditsBG = self.sceneNode.childNode(withName: "lblCreditsBG") as? SKLabelNode
        lblCreditsBG.fontColor = NSColor.black
        
        lblExit = self.sceneNode.childNode(withName: "lblExit") as? SKLabelNode
        lblExitBG = self.sceneNode.childNode(withName: "lblExitBG") as? SKLabelNode
        lblExitBG.fontColor = NSColor.black
        
        lblContinueGame = self.sceneNode.childNode(withName: "lblContinueGame") as? SKLabelNode
        lblContinueGameBG = self.sceneNode.childNode(withName: "lblContinueGameBG") as? SKLabelNode
        lblContinueGameBG.fontColor = NSColor.black
        
        lblHighscore = self.sceneNode.childNode(withName: "lblHighscore") as? SKLabelNode
        lblHighscoreBG = self.sceneNode.childNode(withName: "lblHighscoreBG") as? SKLabelNode
        lblHighscoreBG.fontColor = NSColor.black
        
        self.isPaused = false
    }
    
    override func showOverlayScene() {
        super.showOverlayScene()
        self.showMenu(show: !self.isShowing)
    }
    
    public func showMenu(show:Bool = true){
        self.isShowing = show
        if(self.isShowing){
            self.menuCursor.showMenuCursor()
        }else{
            self.menuCursor.hideMenuCursor()
        }
    }
    
    public func selectMenuItem(){
        if(menuPos == 2){
//            _ = self.game.stateMachine.enter(SuakeStateMainSetup.self)
        }else if(menuPos == 5){
//            self.game.showDbgMsg(dbgMsg: DbgMsgs.gameQuitApp)
//            self.game.quitSuake3D()
        }
    }

    public func moveMenuCursor(dir:KeyboardDirection){

    }
    
    
    
    override func mouseMovedHandler(with event: NSEvent) {
        if(self.game.stateMachine.currentState is SuakeStateMainMenu){
            let location = event.location(in: self.sceneNode)
            let node = self.game.scnView.overlaySKScene?.atPoint(location)
//            let node = self.sceneNode.atPoint(location) //self.atPoint(location)
                if(node != selMenuItem && (node == self.lblSinglePlayer ||
                    node == self.lblMultiPlayer ||
                    node == self.lblSettings ||
                    node == self.lblCredits ||
                    node == self.lblHighscore ||
                    node == self.lblExit ||
                    node == self.lblContinueGame)){

                selMenuItem = node
                self.lblMultiPlayerBG.fontColor = (node == self.lblMultiPlayer ? NSColor.yellow : NSColor.black)
                self.lblSinglePlayerBG.fontColor = (node == self.lblSinglePlayer ? NSColor.yellow : NSColor.black)
                self.lblCreditsBG.fontColor = (node == self.lblCredits ? NSColor.yellow : NSColor.black)
                self.lblSettingsBG.fontColor = (node == self.lblSettings ? NSColor.yellow : NSColor.black)
                self.lblHighscoreBG.fontColor = (node == self.lblHighscore ? NSColor.yellow : NSColor.black)
                self.lblExitBG.fontColor = (node == self.lblExit ? NSColor.yellow : NSColor.black)
                self.lblContinueGameBG.fontColor = (node == self.lblContinueGame ? NSColor.yellow : NSColor.black)
                self.game.soundManager.playSound(soundType: .menuItemChanged)
                    self.lblInd.position.y = node!.position.y
                    self.lblIndBG.position.y = node!.position.y
            }
        }
    }
    
    func presentGame(match: GKMatch) {
        self.game.matchHelper.match = match
        self.game.matchHelper.match.delegate = self.game.matchHelper
        self.game.stateMachine.enter(SuakeStateReadyToPlay.self)
        var tmp = -1
        tmp /= -1
        
    }
    
    func didChangeAuthStatus(isAuthenticated: Bool){
        var tmp = -1
        tmp /= -1
    }
    
    func presentGameCenterAuth(viewController: NSViewController?){
        var tmp = -1
        tmp /= -1
    }
    
    func presentMatchmaking(viewController: NSViewController?){
        var tmp = -1
        tmp /= -1
    }
//    func presentGame(match: GKMatch)
    
    var gameState:SuakeBaseState!
    
    override func mouseDownHandler(in view: NSView, with event: NSEvent) -> Bool {
        if(self.game.stateMachine.currentState is SuakeStateMainMenu){
            let location = event.location(in: self.sceneNode)
            let node = self.sceneNode.atPoint(location)
            if(node == self.lblSinglePlayer){
                self.game.stateMachine.enter(SuakeStateReadyToPlay.self)
            }else if(node == self.lblMultiPlayer){
                
//                GameCenterHelper.helper.delegate = self
//                GameCenterHelper.helper.presentMatchmaker()
//                self.game.gameCenterHelper.delegate = self
                
            }else if(node == self.lblContinueGame){
                self.game.stateMachine.returnToOldState(saveOldState: false)
            }else if(node == self.lblSettings){
                //_ = self.game.stateMachine.enter(stateClass: SuakeStateDeveloperSetup.self, saveOldState: false)
//                _ = self.game.stateMachine.enter(stateClass: SuakeStateMainSetup.self, saveOldState: true)
            }else if(node == self.lblExit){
                self.game.showDbgMsg(dbgMsg: SuakeMsgs.gameQuitApp)
                self.game.quitSuake3D()
            }
            return true
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
