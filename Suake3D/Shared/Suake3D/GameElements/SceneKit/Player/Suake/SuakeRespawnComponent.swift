//
//  SuakeRespawnComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 13.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeRespawnComponent: SuakeBaseComponent {
    
    var playerEntity:SuakePlayerEntity!
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        self.playerEntity = self.entity as? SuakePlayerEntity
    }
    
    func respawnSuake(completion: @escaping () -> Void){
        
        self.playerEntity.playerComponent.currentSuakeComponent.node.opacity = 0.0
        self.playerEntity.playerComponent.currentSuakeComponent.isStopped = true
        
        let newPos:SCNVector3 = self.game.levelManager.gameBoard.getRandomFreePos(diff: 2)
        self.game.locationEntityManager.addLocationToScene(pos: newPos)
        if(self.playerEntity.dir == .UP){
            self.playerEntity.pos = SCNVector3(newPos.x, 0, newPos.z - 1)
        }else if(self.playerEntity.dir == .DOWN){
            self.playerEntity.pos = SCNVector3(newPos.x, 0, newPos.z + 1)
        }else if(self.playerEntity.dir == .LEFT){
            self.playerEntity.pos = SCNVector3(newPos.x - 1, 0, newPos.z)
        }else if(self.playerEntity.dir == .RIGHT){
            self.playerEntity.pos = SCNVector3(newPos.x + 1, 0, newPos.z)
        }
        self.game.overlayManager.hud.overlayScene!.map.reposNode(playerNode: self.game.overlayManager.hud.overlayScene!.map.suakeOwnNode, pos: newPos)
        self.playerEntity.playerComponent.currentSuakeComponent.node.runAction(SCNAction.fadeIn(duration: 3.0), completionHandler: {
            self.game.stateMachine.enter(SuakeStatePlaying.self)
            self.playerEntity.healthComponent.died = false
            self.playerEntity.playerComponent.currentSuakeComponent.isStopped = false
            self.playerEntity.cameraComponent.moveFollowCamera(turnDir: .Straight, duration: 0.0)
//            self.playerEntity.moveComponent.nextMove()
        })
        self.playerEntity.cameraComponent.moveFollowCamera(turnDir: .Straight, duration: 0.0)
        var duration:TimeInterval = 3.0
        self.playerEntity.playerComponent.currentSuakeComponent.node.isPaused = false
        self.playerEntity.playerComponent.currentSuakeComponent.node.runAction(SCNAction.repeat(SCNAction.sequence([SCNAction.run({_ in
//            if(duration == 3.0){
//                self.game.overlayManager.hud.showMsg(msg: "Respawn in \( duration.format(using: [.second])!) seconds")
//            }else{
//                self.game.overlayManager.hud.msgComponent.changeMsg(msg: "Respawn in \(duration.format(using: [.second])!) seconds")
//            }
            self.game.overlayManager.hud.msgComponent.showMsgFadeAndScale2Big(msg: "Respawn in \( duration.format(using: [.second])!) seconds")//.Big.showMsg(msg: "Respawn in \( duration.format(using: [.second])!) seconds")
            duration -= 1-0
        }), SCNAction.wait(duration: 1.0)]), count: 4))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
