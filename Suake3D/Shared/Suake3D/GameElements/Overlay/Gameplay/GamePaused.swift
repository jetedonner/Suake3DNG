//
//  CreditsSkScene.swift
//  Suake3D
//
//  Created by dave on 01.08.18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
import Foundation
import SpriteKit

class GamePaused: SuakeBaseOverlay {
    
    var lblGamePaused:SKLabelNode!
    var lblPressAnyKey:SKLabelNode!

    override init(size: CGSize) {
        super.init(size: size)
    }
    
    convenience init(game:GameController) {
        self.init(size: (game.scnView.window?.frame.size)!)

        self.game = game
        self.overlayType = .paused
    }
    
    func loadScene(){
        if let sceneNode = SKScene.init(fileNamed: "art.scnassets/overlays/gameplay/GamePaused") {
            self.sceneNode = sceneNode
            if let view = self.view {
                view.presentScene(sceneNode) //present the scene.
            }
        }
        self.lblGamePaused = self.sceneNode.childNode(withName: "lblGamePaused") as? SKLabelNode
        self.lblPressAnyKey = self.sceneNode.childNode(withName: "lblPressAnyKey") as? SKLabelNode

        self.isPaused = false
    }
    
    override func showOverlayScene() {
        super.showOverlayScene()
        self.runAnimation()
    }
    
    func runAnimation(){
        self.isPaused = false
        self.sceneNode.isPaused = false
        self.lblPressAnyKey.isPaused = false
        self.lblPressAnyKey.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.5), SKAction.scale(to: 1.0, duration: 0.5)]))
            /*SKAction.sequence([
                SKAction.group([
                    SKAction.fadeIn(withDuration: 1.0),
                    SKAction.sequence([
                        SKAction.scale(to: 1.25, duration: 0.5),
                        SKAction.scale(to: 1.0, duration: 0.5)
                    ])
                ]),
                SKAction.group([
                    SKAction.repeat(
                        SKAction.sequence([
                            SKAction.scale(to: 1.25, duration: 0.5),
                            SKAction.scale(to: 1.0, duration: 0.5)
                        ]),
                    count: 2)
                ]),
                SKAction.group([
                    SKAction.fadeOut(withDuration: 1.0),
                    SKAction.sequence([
                        SKAction.scale(to: 1.25, duration: 0.5),
                        SKAction.scale(to: 1.0, duration: 0.5)
                    ])
                ])
            ])*/)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
