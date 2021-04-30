//
//  HUDMsgOnScreenComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class HUDMsgOnScreenComponent: BaseHUDComponent {
    
    var hud:HUDOverlayScene!
    var msgLable:SKLabelNode = SKLabelNode(fontNamed: "DpQuake")
    
    override init(game: GameController) {
        super.init(game: game, node: self.msgLable)
    }
    
    func setAndShowLbl(msg:String, pos:SCNVector3){
        self.reposMsgLbl(pos: pos)
        self.msgLable.text = msg
        self.msgLable.setScale(1.0)
        self.msgLable.isHidden = false
        self.msgLable.alpha = 1.0
        self.msgLable.run(SKAction.group([SKAction.fadeOut(withDuration: 1.0), SKAction.scale(to: 1.25, duration: 1.0), SKAction.move(by: CGVector(dx: 0, dy: 80.0), duration: 1.0)]))
    }
    
    func reposMsgLbl(pos:SCNVector3){
        let pos2D:SCNVector3 = self.game.scnView.projectPoint(SCNVector3(pos.x, pos.y + 40, pos.z))
        if(pos2D.z < 1.0 && pos2D.z > 0.5){
            self.msgLable.isHidden = false
            self.msgLable.position = CGPoint(x: pos2D.x, y: pos2D.y + 40)
        }else{
            self.msgLable.isHidden = true
        }
    }
    
    func setupMsg(hud:HUDOverlayScene){
        self.hud = hud
        self.hud.scene?.addChild(self.node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
