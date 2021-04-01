//
//  FadeViewAfterDeath.swift
//  Suake3D
//
//  Created by Kim David Hauser on 28.01.21.
//  Copyright © 2021 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class FadeViewAfterDeath:SuakeGameClass{
    
    let newOverl:SKScene
    let sh:SKShapeNode
    let text:SKLabelNode
    
    override init(game:GameController){
        self.newOverl = SKScene(size: CGSize(width: 1280, height: 800))
        self.sh = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: 1280, height: 800)))
        self.text = SKLabelNode(text: "You hit suicide!")
        
        super.init(game: game)
        self.setupFadeViewAfterDeath()
    }
    
    
    func setupFadeViewAfterDeath(){
        
        text.fontSize = 34
        text.fontColor = .white
        text.fontName = "DpQuake"
        text.position = CGPoint(x: CGSize(width: 1280, height: 800).width / 2, y: CGSize(width: 1280, height: 800).height / 2)
        text.alpha = 0.0
        sh.fillColor = .red
        sh.strokeColor = .red
        sh.alpha = 0.0
        newOverl.addChild(sh)
        newOverl.addChild(text)
    }
    
    func hideFadeOut(){
        self.newOverl.alpha = 0.0
    }
    
    func showDeathFadeOut(playerType:SuakePlayerType = .OwnSuake, completion: @escaping () -> Void){
            
        self.newOverl.alpha = 1.0
        
        self.text.alpha = 0.0
        self.sh.alpha = 0.0
        
        switch playerType {
        case .OwnSuake:
            self.text.text = "You hit suicide!"
        case .OppSuake:
            self.text.text = "The opponent killed you!"
        case .Droid:
            self.text.text = "A droid killed you!"
        default:
            self.text.text = "You died in action!"
        }
    
        self.game.scnView.overlaySKScene = newOverl
        self.sh.run(SKAction.fadeAlpha(to: 1.0, duration: 1.0))
        self.text.run(
            SKAction.sequence([
                SKAction.group([
                    SKAction.fadeIn(withDuration: 0.5),
                    SKAction.sequence([
                        SKAction.scale(to: 1.25, duration: 0.25),
                        SKAction.scale(to: 1.0, duration: 0.25)
                    ])
                ]),
                SKAction.group([
                    SKAction.fadeOut(withDuration: 0.5),
                    SKAction.sequence([
                        SKAction.scale(to: 1.25, duration: 0.25),
                        SKAction.scale(to: 1.0, duration: 0.25)
                    ])
                ])
            ]), completion: completion)
    }
}
