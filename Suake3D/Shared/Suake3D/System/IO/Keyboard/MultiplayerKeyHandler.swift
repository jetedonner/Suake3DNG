//
//  PressAnyKeyHandler.swift
//  Suake3D
//
//  Created by Kim David Hauser on 11.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit
import NetTestFW

class MultiplayerKeyHandler:SuakeGameClass{
    
    override init(game:GameController){
        super.init(game: game)
    }
    
    func handleKeyPress(pressedKey:KeyboardDirection)->Bool{
        if(!self.game.gameCenterHelper.isMultiplayerGameRunning || self.game.stateMachine.currentState is SuakeStateMatchOver){
            return false
        }else{
            if(pressedKey == .KEY_SPACE){
                self.game.gameCenterHelper.matchMakerHelper.sendData(msgTyp: .shootWeaponMsg)
                return true
            }else{
                var turnDir:TurnDir = .Straight
                switch pressedKey {
                case .KEY_W:
                    turnDir = .Straight
                    break
                case .KEY_A:
                    turnDir = .Left
                    break
                case .KEY_S:
                    turnDir = .Stop
                    break
                case .KEY_D:
                    turnDir = .Right
                    break
                case .KEY_LEFT:
                    turnDir = .Left
                    break
                case .KEY_RIGHT:
                    turnDir = .Right
                    break
                case .KEY_UP:
                    turnDir = .Straight
                    break
                case .KEY_DOWN:
                    turnDir = .Stop
                    break
                default:
                    return false
                }
                self.game.gameCenterHelper.matchMakerHelper.sendTurnMsg(turnDir: turnDir, position: self.game.playerEntityManager.ownPlayerEntity.pos)
                return true
            }
        }
    }
}
