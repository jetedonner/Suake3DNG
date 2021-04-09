//
//  GameLoading.swift
//  Suake3D-swift
//
//  Created by dave on 11.10.18.
//  Copyright © 2018 com.apple. All rights reserved.
//

import Foundation
import SpriteKit

class GameCenterSkScene : SuakeBaseOverlay {
    
    let lblColor:SKColor = SKColor.white
    var lblPrecent:SKLabelNode = SKLabelNode(text: "0%")
    var lblDesc:SKLabelNode!
    var btnCancel:SKLabelNode!
    var lblCancel:SKLabelNode!
    
    var baseBar:SKSpriteNode!
    var progress:SKSpriteNode!
    
    var progressSteps:CGFloat = 1.0
    
    public var _hasNewProgress:Bool = false
    var hasNewProgress:Bool{
        get {
            var result:Bool = false
            nameQueueHasNewProgress.sync {
                result = self._hasNewProgress
            }
            return result
        }
        set {
            nameQueueHasNewProgress.async(flags: .barrier) {
                self._hasNewProgress = newValue
            }
        }
    }
    
    public var _newProgressPercent:Int = 0
    var newProgressPercent:Int{
        get {
            var result:Int = 0
            nameQueueNewProgressPercent.sync {
                result = self._newProgressPercent
            }
            return result
        }
        set {
            nameQueueNewProgressPercent.async(flags: .barrier) {
                self._newProgressPercent = newValue
            }
        }
    }
    
    public var _newProgressMsg:String = ""
    var newProgressMsg:String{
        get {
            var result:String = ""
            nameQueueNewProgressMsg.sync {
                result = self._newProgressMsg
            }
            return result
        }
        set {
            nameQueueNewProgressMsg.async(flags: .barrier) {
                self._newProgressMsg = newValue
            }
        }
    }
    
    private let nameQueueNewProgressPercent = DispatchQueue(label: "newProgressPercent.lock.queue", qos: .default, attributes: .concurrent)
    private let nameQueueNewProgressMsg = DispatchQueue(label: "newProgressMsg.lock.queue", qos: .default, attributes: .concurrent)
    private let nameQueueHasNewProgress = DispatchQueue(label: "hasNewProgress.lock.queue", qos: .default, attributes: .concurrent)
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    convenience init(game:GameController) {
        self.init(size: (game.scnView.window?.frame.size)!)
        
        self.game = game
        self.overlayType = .loading
    }
    
    func loadScene(){
        if let sceneNode = SKScene.init(fileNamed: "art.scnassets/overlays/gameplay/GameCenter") {
            self.sceneNode = sceneNode
            if let view = self.view {
                view.presentScene(sceneNode) //present the scene.
            }
            self.sceneNode.isPaused = false
        }

        baseBar = self.sceneNode.childNode(withName: "prgProgress") as? SKSpriteNode
        progressSteps = baseBar.frame.width / 100
        lblDesc = self.sceneNode.childNode(withName: "lblDesc") as? SKLabelNode
        btnCancel = self.sceneNode.childNode(withName: "btnCancel") as? SKLabelNode
        lblCancel = self.sceneNode.childNode(withName: "lblCancel") as? SKLabelNode
        
        progress = SKSpriteNode(color: NSColor.red, size: CGSize(width: CGFloat(0.0), height: CGFloat(baseBar.frame.height)))
        progress.position = CGPoint(x: baseBar.frame.minX, y: baseBar.frame.minY)
        progress.anchorPoint = CGPoint(x: 0, y: 0)
        progress.zPosition = 0
        self.sceneNode.addChild(progress)
        
        let edges = SKShapeNode(rect: baseBar.frame)
        edges.fillColor = NSColor.clear
        edges.strokeColor = NSColor.black
        self.sceneNode.addChild(edges)
        
        lblPrecent.fontColor = lblColor
        lblPrecent.fontSize = SuakeVars.progressBarFontSize
        lblPrecent.fontName = SuakeVars.defaultFontName
        lblPrecent.zPosition = 1
        lblPrecent.position = CGPoint(x: baseBar.frame.midX  - (lblPrecent.frame.width / 2), y: baseBar.frame.midY - (lblPrecent.frame.height / 2))
        self.sceneNode.addChild(lblPrecent)
    }
    
    public func initProgressLoop(){
        let wait = SKAction.wait(forDuration: 0.1)
        let action = SKAction.run({
            if(self.hasNewProgress){
                // your code here ...
                self.hasNewProgress = false
                if(self.newProgressPercent < 100){
                    self.lblDesc.text = self.newProgressMsg
                    self.lblPrecent.text = "" + self.newProgressPercent.description + "%"
                    self.lblPrecent.position = CGPoint(x: self.baseBar.frame.midX  - (self.lblPrecent.frame.width / 2), y: self.baseBar.frame.midY - (self.lblPrecent.frame.height / 2))
                    let curPrgWidth = CGFloat(self.newProgressPercent) * self.progressSteps
                    if(curPrgWidth <= self.baseBar.frame.width){
                        self.progress.size.width = curPrgWidth
                    }
                }else{
                    self.sceneNode.removeAllActions()
                    if(self.completitionHandler != nil){
                        self.completitionHandler!()
                    }
                    //self.removeFromParent()
                }
            }
        })
        self.sceneNode.isPaused = false
        self.sceneNode.run(SKAction.repeatForever(SKAction.sequence([action, wait])))
    }
    
    public func finishProgressLoop(){
        self.newProgressPercent = 100
        self.sceneNode.removeAllActions()
        self.sceneNode.removeFromParent()
    }
    
    var completitionHandler:(() -> Void)? = nil
    func setProgress(curPrecent:Int, msg:String, completitionHandler block: (() -> Void)? = nil){
        self.newProgressPercent = curPrecent
        self.newProgressMsg = msg
        self.hasNewProgress = true
        self.completitionHandler = block
    }
    
    
    var progressInfiniteRunning:Bool = false
    
    func startProgressInfinite(msg:String){
        self.progressInfiniteRunning = true
        self.lblPrecent.isHidden = true
        self.setProgressInfinite(progress: 0, msg: msg)
    }
    
    func stopProgressInfinite(){
        self.progressInfiniteRunning = false
        self.lblPrecent.isHidden = false
        self.sceneNode.removeAllActions()
        self.initProgressLoop()
    }
    
    func setProgressInfinite(progress:Int, msg:String){
        let percent:Int = progress + 1
        self.sceneNode.run(SKAction.sequence([SKAction.run {
            if(self.progressInfiniteRunning){
                self.setProgress(curPrecent: percent, msg: msg)
            }
        }, SKAction.wait(forDuration: TimeInterval(1 / 10)), SKAction.run {
            if(self.progressInfiniteRunning){
                self.setProgressInfinite(progress: (percent < 100 ? percent : 0), msg: msg)
            }
        }]))
    }
    
    
    func progressTrip(from:Int, to:Int, stepMilliSec:Int, parentCnt:Int? = nil){
        var cnt:Int = 0
        if(parentCnt != nil){
            cnt = parentCnt!
        }
        self.sceneNode.run(SKAction.sequence([SKAction.run {
            self.setProgress(curPrecent: (to - cnt) + from, msg: self.newProgressMsg)
            cnt += 1
        }, SKAction.wait(forDuration: TimeInterval(stepMilliSec / 100)), SKAction.run {
            self.progressTrip(from: from, to: to, stepMilliSec: stepMilliSec, parentCnt: cnt)
        }]))
    }
    
    override func showOverlayScene(){
        super.showOverlayScene()
        self.initProgressLoop()
    }
    
    override func mouseDownHandler(in view: NSView, with event: NSEvent) -> Bool {
//        if(self.game.stateMachine.currentState is SuakeStateMainMenu){
            let location = event.location(in: self.sceneNode)
            let node = self.sceneNode.atPoint(location)
        if(node == self.btnCancel || node == self.lblCancel){
//                self.game.stateMachine.enter(SuakeStateReadyToPlay.self)
                self.game.stateMachine.returnToOldState(saveOldState: false)
            }/*else if(node == self.lblMultiPlayer){
                
                GameCenterHelper.helper.delegate = self
                GameCenterHelper.helper.presentMatchmaker()
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
            }*/
            return true
//        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
