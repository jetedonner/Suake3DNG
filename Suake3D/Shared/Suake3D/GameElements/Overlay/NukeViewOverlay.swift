//
//  NukeViewOverlay.swift
//  Suake3D
//
//  Created by Kim David Hauser on 09.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class NukeViewOverlay: SuakeBaseOverlay {
    
    var startTime:TimeInterval = TimeInterval()
    var startDate:Date = Date()
    let withDelay:Double = 0.001
    
    var lblTMinus:SKLabelNode!
    var lblTime:SKLabelNode!
    var lblDbg:SKLabelNode!
    var countdown:CGFloat = 12.0
    var imgGForce:SKShapeNode!
    var imgVelo:SKShapeNode!
    var imgCrosshair:SKSpriteNode!
    
    var _upVelo:Bool = false
    var upVelo:Bool {
        get {
           var result:Bool = false
//            nameQueueUpVelo.sync {
                result = self._upVelo
//            }
            return result
        }
        set{
//            nameQueueUpVelo.async(flags: .barrier) {
                self._upVelo = newValue
//            }
        }
    }
    
    var _upGForce:Bool = true
    var upGForce:Bool {
        get {
           var result:Bool = false
//            nameQueueUpGForce.sync {
                result = self._upGForce
//            }
            return result
        }
        set{
//            nameQueueUpGForce.async(flags: .barrier) {
                self._upGForce = newValue
//            }
        }
    }
    
//    private let nameQueueCanceled = DispatchQueue(label: "canceled.lock.queue", qos: .default, attributes: .concurrent)
    var _canceled:Bool = false
    var canceled:Bool {
        get {
            var result:Bool = false
//            nameQueueCanceled.sync {
                result = self._canceled
//            }
            return result
        }
        set {
//            nameQueueCanceled.async(flags: .barrier) {
                self._canceled = newValue
//            }
        }
    }
    
    
    
//    convenience init(game:GameController){
//        self.init(fileNamed: "art.scnassets/overlays/gameplay/NukeViewOverlay")!
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    convenience init(game:GameController) {
        self.init(size: (game.scnView.window?.frame.size)!)
        
        self.game = game
        self.overlayType = .loading
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadScene(){
        if let sceneNode = SKScene.init(fileNamed: "art.scnassets/overlays/gameplay/NukeViewOverlay") {
            self.sceneNode = sceneNode
            if let view = self.view {
                view.presentScene(sceneNode) //present the scene.
            }
            self.sceneNode.isPaused = false
        }

        self.game = game
        self.overlayType = .nukeView
        
        lblTMinus = (self.sceneNode.childNode(withName: "lblTMinus") as! SKLabelNode)
        lblTime = (self.sceneNode.childNode(withName: "lblTime") as! SKLabelNode)
        lblDbg = (self.sceneNode.childNode(withName: "lblDbg") as! SKLabelNode)
        
        imgVelo = (self.sceneNode.childNode(withName: "imgVeloVal") as! SKShapeNode)
        imgGForce = (self.sceneNode.childNode(withName: "imgGForceVal") as! SKShapeNode)
        imgCrosshair = (self.sceneNode.childNode(withName: "imgCrosshair") as! SKSpriteNode)
        imgCrosshair.texture = SKTexture(imageNamed: "art.scnassets/overlays/gameplay/images/testCrosshair.png")
        
//        self.lblGamePaused = self.childNode(withName: "lblGamePaused") as? SKLabelNode
//        self.lblPressAnyKey = self.childNode(withName: "lblPressAnyKey") as? SKLabelNode

        self.isPaused = false
    }
    
    func startOverlay(){
        self.startTime = Date().timeIntervalSinceNow
        self.startDate = Date()
        self.lblTMinus.xScale = 1.0
        self.lblTMinus.yScale = 1.0
        self.canceled = false
        
//        self.initProgressLoop()
    }
    
    
    let TMINUS_SECONDS:TimeInterval = 12.5
    let TMINUS_ALERTLIMIT_1_SECONDS:TimeInterval = 7.0
    let TMINUS_ALERTLIMIT_2_SECONDS:TimeInterval = 5.0
    let TMINUS_ALERTLIMIT_3_SECONDS:TimeInterval = 3.0
    var lastLimitReached:Bool = false
    
    override func update(_ currentTime: TimeInterval) {
        
        let deltaTime = Date().timeIntervalSince(self.startDate)
        if(deltaTime >= self.TMINUS_SECONDS){
            self.isPaused = true
            self.game.showDbgMsg(dbgMsg: "Exploding nuke after timeout of: " + deltaTime.description)
            self.game.overlayManager.showOverlay4GameState(type: .playing)
            self.game.scnView.overlaySKScene?.update(currentTime)
        }else{
            if((self.TMINUS_SECONDS - deltaTime) <= self.TMINUS_ALERTLIMIT_3_SECONDS){
                self.lblTMinus.fontColor = .red
                if(self.lastLimitReached){
                    self.lastLimitReached = false
                    self.lblTMinus.removeAllActions()
                }
                if(!self.lblTMinus.hasActions()){
                    self.lblTMinus.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(by: 1.2, duration: 0.2), SKAction.scale(by: 1.2, duration: 0.2).reversed()])))
                }
            }else if((self.TMINUS_SECONDS - deltaTime) <= self.TMINUS_ALERTLIMIT_2_SECONDS){
                self.lblTMinus.fontColor = .orange
                if(!self.lastLimitReached){
                    self.lastLimitReached = true
                }
                if(!self.lblTMinus.hasActions()){
                    self.lblTMinus.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(by: 1.2, duration: 0.35), SKAction.scale(by: 1.2, duration: 0.35).reversed()])))
                }
            }else if((self.TMINUS_SECONDS - deltaTime) <= self.TMINUS_ALERTLIMIT_1_SECONDS){
                self.lblTMinus.fontColor = .yellow
            }else{
                if(self.lastLimitReached){
                    self.lastLimitReached = false
                }
                self.lblTMinus.fontColor = .white
                if(self.lblTMinus.hasActions()){
                    self.lblTMinus.removeAllActions()
                }
            }
            let d = Date()
            let df = DateFormatter()
            df.dateFormat = "H:m:ss.SS"
            
            self.lblTMinus.text = "T: " + NumberFormatterHelper.getFormatedString(number: NSNumber(value: Float(self.TMINUS_SECONDS - deltaTime)))
            self.lblTime.text = df.string(from: d)
            
            // DATA RACE upVelo and pos. imgVelo
            if(!self.upVelo && self.imgVelo.yScale > 0.5){
                self.imgVelo.yScale -= 0.1
            }else{
                self.upVelo = true
                if(self.imgVelo.yScale < 1.9){
                    self.imgVelo.yScale += 0.1
                }else{
                    self.upVelo = false
                }
            }
            
            if(!self.upGForce && self.imgGForce.yScale > 0.1){
                self.imgGForce.yScale -= 0.01
            }else{
                self.upGForce = true
                if(self.imgGForce.yScale < 2.6){
                    self.imgGForce.yScale += 0.01
                }else{
                    self.upGForce = false
                }
            }
        }
    }
    
//    public func initProgressLoop(){
//        let wait = SKAction.wait(forDuration: 0.15)
//        let action = SKAction.run({
//            self.updateTMinus()
//        })
//        self.isPaused = false
//        self.run(SKAction.repeatForever(SKAction.sequence([action, wait])))
//    }
}
