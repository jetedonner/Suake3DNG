//
//  SuakeGameStateHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class SuakeGameStateHelper: SuakeGameClass {
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func startMatch() {
        self.startMatch(withCountdown: self.game.levelManager.currentLevel.levelConfig.levelSetup.showCountdown)
    }
    
    func startMatch(withCountdown:Bool = false) {
        if(withCountdown){
            self.game.soundManager.playSound(soundType: .beep)
            self.game.overlayManager.hud.msgComponent.showMsgFadeAndScale2Big(msg: "3", completionHandler: {
                self.game.soundManager.playSound(soundType: .beep)
                self.game.overlayManager.hud.msgComponent.showMsgFadeAndScale2Big(msg: "2", completionHandler: {
                    self.game.soundManager.playSound(soundType: .beep2)
                    self.game.overlayManager.hud.msgComponent.showMsgFadeAndScale2Big(msg: "1", completionHandler: {
                        self.game.stateMachine.enter(stateClass: SuakeStatePlaying.self)
                    })
                })
            })
        }else{
            self.game.stateMachine.enter(stateClass: SuakeStatePlaying.self)
        }
    }
}
