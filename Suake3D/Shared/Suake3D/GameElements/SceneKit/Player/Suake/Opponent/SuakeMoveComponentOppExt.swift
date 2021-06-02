//
//  SuakeMoveComponentOppExt.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit
import NetTestFW

extension SuakeMoveComponent{
    
    func nextMoveOpp(deltaTime seconds: TimeInterval = 1.0){
        var newPos:SCNVector3 = self.playerEntity.pos
        var daNextTurnDir:TurnDir = .Straight
        if((self.playerEntity as! SuakeOppPlayerEntity).turnQueue.count > 0){
            daNextTurnDir = (self.playerEntity as! SuakeOppPlayerEntity).turnQueue.remove(at: 0)
        }else{
            self.game.showDbgMsg(dbgMsg: "NO MORE PATH FOR OPPONENT!!!")
            if(self.checkNextMoveNG(pos: self.overNextPos).contains(.goody)){
                self.game.showDbgMsg(dbgMsg: "GOODY HIT by OWN")
                self.game.playerEntityManager.goodyEntity.goodyHit(playerEntity: self.playerEntity)
                self.game.playerEntityManager.oppPlayerEntity.loadGridGraph(afterGoodyHit: true)
                self.playerEntity._pos = self.nextPos
                self.nextMoveOpp(deltaTime: seconds)
                return
            }
            return
        }
        
        let nextSuakeComponent:NewSuakePartComponentStruct = PosHelper.getNewSuakeParts(suakeEntity: self.entity as! SuakeOppPlayerEntity, newTurnDir: daNextTurnDir, currentSuakePart: self.playerEntity.playerComponent.currentSuakeComponent.suakePart)
        
//        let nextSuakePlayerNodeComponent:SuakePlayerNodeComponent = self.playerEntity.playerComponent.getNextSuakePlayerNodeComponent(turnDir: daNextTurnDir)
        
        let nextDir:SuakeDir = SuakeDirTurnDirHelper.getSuakeDirFromTurnDir(oldSuakeDir: self.playerEntity.dir, turnDir: daNextTurnDir)

//        if(self.playerEntity.playerType == .OppSuake){
        newPos = self.getNextPos4DirNG(daDir: self.playerEntity.dirOld, suakePart: /*nextSuakePlayerNodeComponent.suakePart,*/ nextSuakeComponent.nextSuakePart, daPos: newPos)
//            newPos = self.nextPos(dir: self.playerEntity.dir, suakePart: nextSuakePlayerNodeComponent.suakePart)
//        }
        
        self.game.showDbgMsg(dbgMsg: "newPos: \(newPos), nextDir: \(nextDir), daNextTurnDir: \(daNextTurnDir), nextSuakePart: \(nextSuakeComponent.nextSuakePart)")
        
        self.nextPos = newPos
        self.overNextPos = self.getOverNextPos(daDir: nextDir, suakePart: /*nextSuakePlayerNodeComponent.suakePart*/ nextSuakeComponent.nextSuakePart, daPos: newPos)
        
        let nextMoveResult:NextMoveResult = self.checkNextMoveNG(pos: newPos)
        if(nextMoveResult.contains(.moveNotOk)){
            if(nextMoveResult.contains(.wall)){
                self.game.showDbgMsg(dbgMsg: "WALL HIT!!!")
                self.playerEntity.playerDied()
            }else if(nextMoveResult.contains(.suakeOpp)){
                self.game.showDbgMsg(dbgMsg: "OPPONENT HIT!!!")
                self.playerEntity.playerDied()
            }
        }else{
            if(nextMoveResult.contains(.goody)){
                self.game.showDbgMsg(dbgMsg: "GOODY HIT by OWN")
//                GameCenterHelper.achievements.add2GoodiesAchivement()
                self.game.playerEntityManager.goodyEntity.goodyHit(playerEntity: self.playerEntity)
            }else if(nextMoveResult.contains(.mgPickup)){
                self.game.showDbgMsg(dbgMsg: "MGPICKUP HIT by OWN")
            }else if(nextMoveResult.contains(.medkit)){
                self.game.showDbgMsg(dbgMsg: "MEDKIT HIT by OWN")
            }/*else if(nextMoveResult.contains(.portal)){
                self.game.showDbgMsg(dbgMsg: "PORTAL HIT by OWN")
                (nextMoveResult.fieldEntity as! PortalEntity).beamSuakeNode(suakeEntity: self.playerEntity, portal: 0)
            }*/
            self.setAndShowSuakePlayerNodeComponent(newSuakePlayerNodeComponent: nextSuakeComponent.newSuakeComponent)
            if(seconds > 0){
                self.moveNode(newPos: newPos, seconds: seconds)
            }/*else{
//                self.playerEntity._pos = self.nextPos(dir: self.playerEntity.dir, suakePart: nextSuakePlayerNodeComponent.suakePart)
            }*/
//            if(self.playerEntity.dir != nextDir){
//                self.game.overlayManager.hud.overlayScene.arrows.rotateArrows(duration: 1.0, turnDir: (daNextTurnDir == .Left ? .Right : .Left))
//            }
            self.playerEntity.playerComponent.currentSuakeComponent.movePlayerNodeComponent(newTurnDir: daNextTurnDir, newDir: nextDir, deltaTime: seconds)

//            if(!(seconds == 0 && self.playerEntity.playerType == .OppSuake)){
//                if(self.playerEntity.playerComponent.currentSuakeComponent.suakePart == .leftToLeft || self.playerEntity.playerComponent.currentSuakeComponent.suakePart == .rightToRight){
//                    SuakeDirTurnDirHelper.initNodeRotation(node: self.playerEntity.playerComponent.mainNode, dir: self.playerEntity.dirOld)
//                }
//            }else{
////                if(!afterGoodyHit){
//                    self.playerEntity._pos = self.nextPos(dir: self.playerEntity.dirOld, suakePart: nextSuakePlayerNodeComponent.suakePart)
////                }
//            }
//            self.game.showDbgMsg(dbgMsg: "Opp Next-Pos: \(self.playerEntity.pos)")
            self.playerEntity.dir = nextDir
            self.tmpCnt += 1
        }
    }
//    func nextMoveOpp(deltaTime seconds: TimeInterval = 1.0, afterGoodyHit:Bool = false){
//
////        if(self.tmpCnt == 1){
////            var tmpo = -1
////            tmpo /= -1
////        }
//
//
//
//        var newPos:SCNVector3 = self.playerEntity.pos
//
//        var daNextTurnDir:TurnDir = .Straight
//        if(self.playerEntity.playerType == .OppSuake){
//            if((self.playerEntity as! SuakeOppPlayerEntity).turnQueue.count > 0){
//                daNextTurnDir = (self.playerEntity as! SuakeOppPlayerEntity).turnQueue.remove(at: 0)
//            }else{
//                if(self.oppGoodyHit){
//                    self.game.playerEntityManager.goodyEntity.goodyHit(playerEntity: self.playerEntity)
//                    self.playerEntity._pos = self.nextPos
////                    self.overNextPos
//                    self.game.playerEntityManager.oppPlayerEntity.loadGridGraph(afterGoodyHit: true)
//                    self.oppGoodyHit = false
//                    self.nextMoveOpp(deltaTime: seconds, afterGoodyHit: true)
//                    return
////                    if((self.playerEntity as! SuakeOppPlayerEntity).turnQueue.count > 0){
////                        daNextTurnDir = (self.playerEntity as! SuakeOppPlayerEntity).turnQueue.remove(at: 0)
////                    }else{
////                        return
////                    }
////                    self.nextMoveOpp(deltaTime: seconds)
////                    return
//                }else{
//                    return
//                }
//            }
//         }
//
//        let nextSuakePlayerNodeComponent:SuakePlayerNodeComponent = self.playerEntity.playerComponent.getNextSuakePlayerNodeComponent(turnDir: daNextTurnDir) //newTurnDir)
//        let nextDir:SuakeDir = SuakeDirTurnDirHelper.getSuakeDirFromTurnDir(oldSuakeDir: self.playerEntity.dir, turnDir: daNextTurnDir)
//
//        if(seconds >= 1.0 || self.playerEntity.playerType == .OppSuake){
//            newPos = self.nextPos(dir: self.playerEntity.dir, suakePart: nextSuakePlayerNodeComponent.suakePart)
//        }
//        print("newPos: \(newPos), nextDir: \(nextDir), daNextTurnDir: \(daNextTurnDir)")
//        self.nextPos = newPos
//        self.overNextPos = self.getOverNextPos(daDir: nextDir, suakePart: nextSuakePlayerNodeComponent.suakePart, daPos: newPos)
//
//        let overNextMoveResult:NextMoveResult = self.checkNextMoveNG(pos: self.overNextPos)
//        if(overNextMoveResult.contains(.moveOk)){
//            if(overNextMoveResult.contains(.goody)){
//                self.oppGoodyHit = true
////                self.game.showDbgMsg(dbgMsg: "GOODY HIT by OWN")
////                GameCenterHelper.achievements.add2GoodiesAchivement()
////                self.game.playerEntityManager.goodyEntity.goodyHit(playerEntity: self.playerEntity)
////                self.game.playerEntityManager.oppPlayerEntity.loadGridGraph()
////                self.nextMoveOpp(deltaTime: seconds)
////                return
//            }
//        }
//
//        let nextMoveResult:NextMoveResult = self.checkNextMoveNG(pos: newPos)
//        if(nextMoveResult.contains(.moveNotOk)){
//            if(nextMoveResult.contains(.wall)){
//                self.game.showDbgMsg(dbgMsg: "WALL HIT!!!")
//                self.playerEntity.playerDied()
//            }else if(nextMoveResult.contains(.suakeOpp)){
//                self.game.showDbgMsg(dbgMsg: "OPPONENT HIT!!!")
//                self.playerEntity.playerDied()
//            }
//        }else{
//            if(nextMoveResult.contains(.goody)){
//                self.game.showDbgMsg(dbgMsg: "GOODY HIT by OWN")
////                GameCenterHelper.achievements.add2GoodiesAchivement()
//                self.game.playerEntityManager.goodyEntity.goodyHit(playerEntity: self.playerEntity)
//            }else if(nextMoveResult.contains(.mgPickup)){
//                self.game.showDbgMsg(dbgMsg: "MGPICKUP HIT by OWN")
//            }else if(nextMoveResult.contains(.medkit)){
//                self.game.showDbgMsg(dbgMsg: "MEDKIT HIT by OWN")
//            }else if(nextMoveResult.contains(.portal)){
//                self.game.showDbgMsg(dbgMsg: "PORTAL HIT by OWN")
//                (nextMoveResult.fieldEntity as! PortalEntity).beamSuakeNode(suakeEntity: self.playerEntity, portal: 0)
//            }
//            self.setAndShowSuakePlayerNodeComponent(newSuakePlayerNodeComponent: nextSuakePlayerNodeComponent)
//            if(!(seconds == 0 && self.playerEntity.playerType == .OppSuake)){
//                self.moveNode(newPos: newPos, seconds: seconds)
//            }else{
////                self.playerEntity._pos = self.nextPos(dir: self.playerEntity.dir, suakePart: nextSuakePlayerNodeComponent.suakePart)
//            }
//            if(self.playerEntity.dir != nextDir){
//                self.game.overlayManager.hud.overlayScene.arrows.rotateArrows(duration: 1.0, turnDir: (daNextTurnDir == .Left ? .Right : .Left))
//            }
//            self.playerEntity.playerComponent.currentSuakeComponent.movePlayerNodeComponent(newTurnDir: daNextTurnDir, newDir: nextDir, deltaTime: seconds)
//
//            if(!(seconds == 0 && self.playerEntity.playerType == .OppSuake)){
//                if(self.playerEntity.playerComponent.currentSuakeComponent.suakePart == .leftToLeft || self.playerEntity.playerComponent.currentSuakeComponent.suakePart == .rightToRight){
//                    SuakeDirTurnDirHelper.initNodeRotation(node: self.playerEntity.playerComponent.mainNode, dir: self.playerEntity.dirOld)
//                }
//            }else{
//                if(!afterGoodyHit){
//                    self.playerEntity._pos = self.nextPos(dir: self.playerEntity.dirOld, suakePart: nextSuakePlayerNodeComponent.suakePart)
//                }
//            }
//            self.game.showDbgMsg(dbgMsg: "Opp Next-Pos: \(self.playerEntity.pos)")
//            self.playerEntity.dir = nextDir
//            self.tmpCnt += 1
//        }
//    }
}
