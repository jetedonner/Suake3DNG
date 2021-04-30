//
//  HUDScoreComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit
import GameplayKit
import GameKit

class HUDMsgComponent: BaseHUDComponent {
    
    var lblMsg:SKLabelNode!
    var hud:HUDOverlayScene!
    
    var isHidden:Bool{
        get{ return lblMsg.isHidden }
    }
    
    override init(game:GameController) {
        super.init(game: game)
    }
    
    func setupMsg(hud:HUDOverlayScene){
        self.hud = hud
        self.lblMsg = SKLabelNode(fontNamed: "DpQuake")
        self.hud.scene?.addChild(self.lblMsg)
        self.lblMsg.text = ""
        self.lblMsg.isHidden = false
        
        self.lblMsg.verticalAlignmentMode = .center
        self.lblMsg.horizontalAlignmentMode = .center
    }
    
    let fadeDuration:TimeInterval = 0.5
    let scaleDuration:TimeInterval = 0.5
    let repeatCount:Int = 2
    let scaleIn:SKAction = SKAction.scale(to: 1.25, duration: 0.5)
    let scaleOut:SKAction = SKAction.scale(to: 1.0, duration: 0.5)
    
    func changeMsg(msg:String){
        self.hud.sceneNode.isPaused = false
        self.lblMsg.isPaused = false
        self.lblMsg.run(SKAction.run {
            self.lblMsg.text = msg
        })
    }
    
    func showMsg(msg:String){
        self.hud.sceneNode.isPaused = false
        self.lblMsg.isPaused = false
        self.lblMsg.setScale(1.0)
        self.lblMsg.run(SKAction.sequence([SKAction.run {
            self.lblMsg.isHidden = false
            self.lblMsg.alpha = 0.0
            self.lblMsg.text = msg
            
            let windowFrame:NSRect = self.game.scnView.window!.frame
            let mapHeight = windowFrame.height / 2
            let mapWidth = windowFrame.width / 2
            
            self.lblMsg.position.x = mapWidth
            self.lblMsg.position.y = mapHeight + self.lblMsg.frame.height
            
        }, SKAction.group([
            SKAction.fadeIn(withDuration: self.fadeDuration),
                SKAction.sequence([self.scaleIn, self.scaleOut])
            ]),
            SKAction.group([
                SKAction.wait(forDuration: self.scaleDuration * 2 * Double(self.repeatCount)),
                    SKAction.repeat(
                        SKAction.sequence([self.scaleIn, self.scaleOut]), count: self.repeatCount)
            ]),
            SKAction.group([
                SKAction.fadeOut(withDuration: self.fadeDuration),
                    SKAction.sequence([self.scaleIn, self.scaleOut])
            ])
        ]))
    }
    
    let scale2BigFactor:CGFloat = 5.5
    
    func showMsgFadeAndScale2Big(msg:String, duration:TimeInterval = 1.0, completionHandler: (() -> Void)? = nil){
        self.lblMsg.removeAllActions()
        self.hud.sceneNode.isPaused = false
        self.lblMsg.isPaused = false
        self.lblMsg.setScale(1.0)
        self.lblMsg.alpha = 1.0
        self.lblMsg.isHidden = false
        self.lblMsg.text = msg
        self.lblMsg.run(SKAction.sequence([SKAction.run {
            self.lblMsg.text = msg
            
            let windowFrame:NSRect = self.game.scnView.window!.frame
            let mapHeight = windowFrame.height / 2
            let mapWidth = windowFrame.width / 2
            
            self.lblMsg.position.x = mapWidth
            self.lblMsg.position.y = mapHeight + self.lblMsg.frame.height
        }, SKAction.group([SKAction.scale(to: self.scale2BigFactor, duration: duration), SKAction.fadeOut(withDuration: duration)])
        ]), completion: {
            if(completionHandler != nil){
                completionHandler!()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
