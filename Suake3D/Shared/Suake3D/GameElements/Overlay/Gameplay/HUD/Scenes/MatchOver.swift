//
//  CreditsSkScene.swift
//  Suake3D
//
//  Created by dave on 01.08.18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
import Foundation
import SpriteKit

class MatchOver: SuakeBaseOverlay {
    
    var lblMatchOver:SKLabelNode!
    var lblPressAnyKey:SKLabelNode!
    var lblWinLose:SKLabelNode!
    
    
    let animationDuration:TimeInterval = 0.8
    let lblScaleFactor:CGFloat = 2.75
    
    let lblAlphaFadeMax:CGFloat = 1.0
    let lblAlphaFadeMin:CGFloat = 0.0
//    var loaded:Bool = false
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    convenience init(game:GameController) {
        self.init(size: (game.scnView.window?.frame.size)!)
        
        self.game = game
        self.overlayType = .matchOver
    }
    
    func loadScene(){
        if let sceneNode = SKScene.init(fileNamed: "art.scnassets/overlays/gameplay/MatchOver") {
            self.sceneNode = sceneNode
            if let view = self.view {
                view.presentScene(sceneNode) //present the scene.
            }
        }
        self.lblMatchOver = self.sceneNode.childNode(withName: "lblMatchOver") as? SKLabelNode
        self.lblPressAnyKey = self.sceneNode.childNode(withName: "lblPressAnyKey") as? SKLabelNode
        self.lblWinLose = self.sceneNode.childNode(withName: "lblWinLose") as? SKLabelNode
        
        
        self.lblMatchOver.alpha = self.lblAlphaFadeMin
        self.lblPressAnyKey.alpha = self.lblAlphaFadeMin
        self.lblWinLose.alpha = self.lblAlphaFadeMin
        
        self.isPaused = false
    }
    
    override func showOverlayScene() {
        super.showOverlayScene()
        self.showMatchOver(lost: false)
    }
    
    func showMatchOver(lost:Bool = true){
        self.isLoaded = false
        self.lblMatchOver.alpha = self.lblAlphaFadeMin
        self.lblPressAnyKey.alpha = self.lblAlphaFadeMin
        self.lblWinLose.alpha = self.lblAlphaFadeMin
        
        if(lost){
            self.lblWinLose.text = "YOU LOST THE MATCH"
            self.lblWinLose.fontColor = NSColor(named: "Suake3DRed")
            self.game.soundManager.playSoundQuake(soundType: .you_lose)
        }else{
            self.lblWinLose.text = "YOU WIN THE MATCH"
            self.lblWinLose.fontColor = NSColor(named: "Suake3DGreen")
            self.game.soundManager.playSoundQuake(soundType: .you_win)
        }
        
        self.game.scnView.isPlaying = true
        self.game.scene.isPaused = false
        self.sceneNode.isPaused = false
        self.lblMatchOver.isPaused = false
        self.lblWinLose.isPaused = false
        self.lblPressAnyKey.isPaused = false
        
        self.lblMatchOver.run(SKAction.sequence([SKAction.scale(to: 1.0, duration: 0.0), SKAction.group([SKAction.fadeAlpha(to: self.lblAlphaFadeMax, duration: self.animationDuration), SKAction.scale(to: self.lblScaleFactor, duration: self.animationDuration)])]))
        
        self.lblWinLose.run(SKAction.sequence([ SKAction.group([SKAction.fadeAlpha(to: self.lblAlphaFadeMax, duration: self.animationDuration)])]))
        
        self.lblPressAnyKey.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.0), SKAction.wait(forDuration: self.animationDuration * 1.5), SKAction.fadeAlpha(to: self.lblAlphaFadeMax, duration: self.animationDuration)]), completion: {
                self.isLoaded = true
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
