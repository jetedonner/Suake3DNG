//
//  OpponentMoveTowardState.swift
//  Suake3D
//
//  Created by Kim David Hauser on 26.05.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class OpponentMoveTowardState: OpponentState {
    
//    let targetEntity:SuakeBaseEntity
//
//    init(game: GameController, entity: SuakeOppPlayerEntity, targetEntity:SuakeBaseEntity, stateDesc: String) {
//        self.targetEntity = targetEntity
//        super.init(game: game, entity: entity, stateDesc: stateDesc)
//    }
    
    internal var target: GKGridGraphNode?
    internal var targetEntity: SuakeBaseNodeEntity?
    
    var changedToSeekMedKit:Bool = false
    var nextPosAfterGoodyOutsideNG:SCNVector3? = nil
    var medKitHitOnPathEnd:Bool = false
    
    init(game: GameController, entity: SuakeOppPlayerEntity, targetEntity: SuakeBaseNodeEntity?, stateDesc: String) {
        self.targetEntity = targetEntity
        super.init(game: game, entity: entity, stateDesc: stateDesc)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
//        if(entity.isBeaming){
//            return
//        }
//        self.nextOppMoveExtNG()
    }
    
    func checkNextMoveContains(result:NextMoveResult, contains:NextMoveResult)->Bool{
        return result.rawValue | contains.rawValue == result.rawValue
    }
    
    func checkNextMoveNG(pos:SCNVector3) -> NextMoveResult {
        var nextMoveResult:NextMoveResult = NextMoveResult(moveResult: .moveOk, pos: pos)
        let resNextMove = self.game.levelManager.checkSuakePos(pos: pos)
        if(!resNextMove){
            nextMoveResult = NextMoveResult(moveResults: [.moveNotOk, .wall])
        }else{
            let nextSuakeField = self.game.levelManager.gameBoard.getGameBoardField(pos: pos)
            
            switch nextSuakeField {
            case .own_suake:
                nextMoveResult = NextMoveResult(moveResults: [.moveNotOk, .suakeOwn], pos: pos)
            case .opp_suake:
                nextMoveResult = NextMoveResult(moveResults: [.moveNotOk, .suakeOpp], pos: pos)
            case .droid:
                nextMoveResult = NextMoveResult(moveResults: [.moveNotOk, .droid], pos: pos)
            case .medKit:
                nextMoveResult.addMoveResult(moveResult: .medkit)
            case .portal,
                 .portalIn,
                 .portalOut:
                nextMoveResult.addMoveResult(moveResult: .portal)
            default:
                break
            }
            
//            let nextFieldItem:SuakeItemType = self.game.levelManager.gameBoard.getGameBoardItem(pos: pos)
//            switch nextFieldItem {
//            case .machinegun:
//                nextMoveResult.addMoveResult(moveResult: .mgPickup)
//            case .shotgun:
//                nextMoveResult.addMoveResult(moveResult: .shotgunPickup)
//            case .rocketlauncher:
//                nextMoveResult.addMoveResult(moveResult: .rpgPickup)
//            case .railgun:
//                nextMoveResult.addMoveResult(moveResult: .railgunPickup)
//            case .sniperrifle:
//                nextMoveResult.addMoveResult(moveResult: .sniperriflePickup)
//            case .nuke:
//                nextMoveResult.addMoveResult(moveResult: .nukePickup)
//            default:
//                break
//            }
            
//            guard let goodyEntity:GoodyEntity = self.game.playerEntityManager.getPlayerEntity(ofType: GoodyEntity.self) as? GoodyEntity else{
//                return nextMoveResult
//            }
            let goodyEntity:GoodyEntity = self.game.playerEntityManager.goodyEntity
            if(goodyEntity.pos.x == pos.x && goodyEntity.pos.z == pos.z){
                nextMoveResult.addMoveResult(moveResult: .goody)
            }
        }
        return nextMoveResult
    }
    
//    func getCost(from:SCNVector3, to:SCNVector3, gridGraph:GKGridGraph<SuakeGridGraphNode>)->CGFloat{
//        
////        let fromNode:SuakeGridGraphNode? = gridGraph.node(atGridPosition: vector_int2(Int32(from.x), Int32(from.z)))!
////        let toNode:SuakeGridGraphNode? = gridGraph.node(atGridPosition: vector_int2(Int32(to.x), Int32(to.z)))!
//        if let fromNode = gridGraph.node(atGridPosition: vector_int2(Int32(from.x), Int32(from.z))), let toNode = gridGraph.node(atGridPosition: vector_int2(Int32(to.x), Int32(to.z))) {
//            return CGFloat(fromNode.cost(to: toNode))
//        }else{
//            return 10000.0
//        }
//    }
//    
//    func reloadGridGraphNG(nextPos:SCNVector3? = nil){
//        let daPos:SCNVector3 = (nextPos != nil ? nextPos!: self.entity.pos)
//        self.entity.opponentAIComponent.gridGraphHelper.loadGridGraph()
//        
//        let vectPos2remove:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.One80, .Left, .Right], curPos: daPos)
//        for vectPos in vectPos2remove {
////            print("Removing Nodes around suake: \(daPos), node: \(vectPos)")
//            self.entity.opponentAIComponent.gridGraphHelper.removeConnection(from: daPos, to: vectPos)
//        }
//        
////        for droid in self.game.playerEntityManager.droidsNotDead {
////            if(droid.followComponent.overNextPosNG != nil){
//////                let vectPos2remove2:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.followComponent.overNextPosNG!) // self.getBackLeftRightPos()
//////                for vectPos in vectPos2remove2 {
//////                    self.entity.followComponent.removeConnection(from: droid.followComponent.overNextPosNG!, to: vectPos)
//////                }
////
//////                let vectPos2remove23:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.followComponent.nextPosNG!) // self.getBackLeftRightPos()
//////                for vectPos in vectPos2remove23 {
//////                    print("REMOVING DROID POS FROM: \(droid.followComponent.nextPosNG) TO: \(vectPos)")
//////                    self.entity.followComponent.removeConnection(from: droid.followComponent.nextPosNG!, to: vectPos)
//////                }
////            }
////
////            let vectPos2remove:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.pos)
////            for vectPos in vectPos2remove {
//////                print("Removing Droid: \(daPos), node: \(vectPos)")
////                self.entity.followComponent.removeConnection(from: droid.pos, to: vectPos)
////            }
////
//////            if(droid.followComponent.nextPosNG != nil){
//////                let vectPos2remove2:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.followComponent.nextPosNG!) // self.getBackLeftRightPos()
//////                for vectPos in vectPos2remove2 {
//////                    print("REMOVING DROID POS FROM: \(String(describing: droid.followComponent.nextPosNG)) TO: \(vectPos)")
//////                    self.entity.followComponent.removeConnection(from: droid.followComponent.nextPosNG!, to: vectPos)
//////                }
//////            }
////        }
//    }
//    
//    func loadPath2TargetNG(afterGoodyHit:Bool = false, doNotRemoveFirst:Bool = false, nextPos:SCNVector3? = nil, skipFirst:Bool = false){
//        
////        self.entity.followComponent.loadPathNG(toEntity: self.targetEntity!, afterGoodyHit: afterGoodyHit, doNotRemoveFirst: doNotRemoveFirst, nextPos: nextPos)
//        
//        self.entity.opponentAIComponent.gridGraphHelper.findPathTo(entity: self.targetEntity as! SuakeBasePlayerEntity)//.loadPathNG(toEntity: self.targetEntity!, afterGoodyHit: afterGoodyHit, doNotRemoveFirst: doNotRemoveFirst, nextPos: nextPos)
//        
////        for vectPos in vectPos2remove {
////            self.entity.followComponent.gridHelper.addConnection(from: daPos, to: vectPos)
////        }
//        self.followPathNG(skipFirst: skipFirst, nextPos: nextPos)
//    }
//    
//    func loadPath2Target(afterGoodyHit:Bool = false, doNotRemoveFirst:Bool = false, nextPos:SCNVector3? = nil, skipFirst:Bool = false, removeDroidOverNextPos:Bool = false){
//        let daPos:SCNVector3 = (nextPos != nil ? nextPos!: self.entity.pos)
//        self.entity.followComponent.gridHelper.loadGridGraph()
//        
//        let vectPos2remove:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.One80, .Left, .Right], curPos: daPos) // self.getBackLeftRightPos()
//        for vectPos in vectPos2remove {
////            print("Removing Nodes around suake: \(daPos), node: \(vectPos)")
//            self.entity.followComponent.removeConnection(from: daPos, to: vectPos)
//        }
//        
//        
//        for droid in self.game.playerEntityManager.droidsNotDead {
//            if(removeDroidOverNextPos){
//                if(droid.followComponent.overNextPosNG != nil){
//                    let vectPos2remove:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.followComponent.overNextPosNG!) // self.getBackLeftRightPos()
//                    for vectPos in vectPos2remove {
//        //                print("Removing Droid: \(daPos), node: \(vectPos)")
//                        self.entity.followComponent.removeConnection(from: droid.followComponent.overNextPosNG!, to: vectPos)
//                    }
//    //                let vectPos2remove2:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.followComponent.overNextPosNG!) // self.getBackLeftRightPos()
//    //                for vectPos in vectPos2remove2 {
//    //                    self.entity.followComponent.removeConnection(from: droid.followComponent.overNextPosNG!, to: vectPos)
//    //                }
//                    
//    //                let vectPos2remove23:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.followComponent.nextPosNG!) // self.getBackLeftRightPos()
//    //                for vectPos in vectPos2remove23 {
//    //                    print("REMOVING DROID POS FROM: \(droid.followComponent.nextPosNG) TO: \(vectPos)")
//    //                    self.entity.followComponent.removeConnection(from: droid.followComponent.nextPosNG!, to: vectPos)
//    //                }
//                }
//            }
//            
//            let vectPos2remove:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.pos) // self.getBackLeftRightPos()
//            for vectPos in vectPos2remove {
////                print("Removing Droid: \(daPos), node: \(vectPos)")
//                self.entity.followComponent.removeConnection(from: droid.pos, to: vectPos)
//            }
//            
////            if(droid.followComponent.nextPosNG != nil){
////                let vectPos2remove2:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: self.entity.dir, relPos: [.Straight, .One80, .Left, .Right], curPos: droid.followComponent.nextPosNG!) // self.getBackLeftRightPos()
////                for vectPos in vectPos2remove2 {
////                    print("REMOVING DROID POS FROM: \(String(describing: droid.followComponent.nextPosNG)) TO: \(vectPos)")
////                    self.entity.followComponent.removeConnection(from: droid.followComponent.nextPosNG!, to: vectPos)
////                }
////            }
//        }
//        
//        self.entity.followComponent.loadPathNG(toEntity: self.targetEntity!, afterGoodyHit: afterGoodyHit, doNotRemoveFirst: doNotRemoveFirst, nextPos: nextPos)
//        
//        for vectPos in vectPos2remove {
//            self.entity.followComponent.gridHelper.addConnection(from: daPos, to: vectPos)
//        }
//        self.followPathNG(skipFirst: skipFirst, nextPos: nextPos)
//    }
//    
//    func followPathNG(skipFirst:Bool = false, nextPos:SCNVector3? = nil){
//        self.followPathNG(followPath: self.entity.followComponent.newPathNG!, skipFirst: skipFirst, nextPos: nextPos)
//    }
//    
//    func followPathNG(followPath:[SuakeGridGraphNode], skipFirst:Bool = false, nextPos:SCNVector3? = nil){
//        if(followPath.count > 0){
//            var curPos:SCNVector3 = (nextPos != nil ? nextPos! : self.entity.pos)
//            var suakeDirs:[SuakeDir] = [SuakeDir]()
//            var turnDirs:[TurnDir] = [TurnDir]()
//            var idx = 0
//            var idx2 = 0
//            var nextTurnDir:TurnDir = .None
//            var inPortal:Bool = false
////            var inPortalEntity:PortalEntity!
//            
//            while idx < followPath.count {
//                var nextNode = followPath[idx]
//                if(nextNode.suakeField.fieldType == .portal){
//                    
//                    if(inPortal){
//                        if(followPath.count > idx + 1){
//                            let portalEnd = nextNode //(nextNode.suakeField.fieldEntity as! PortalEntity).otherPortal
//                            curPos.x = CGFloat((portalEnd.gridPosition.x)) //?.pos.x)!)
//                            curPos.z = CGFloat((portalEnd.gridPosition.y)) //?.pos.z)!)
////                            if(suakeDirs.count > 0){
////                                suakeDirs.append(suakeDirs.last!)
////                            }else{
////                                suakeDirs.append(self.entity.dir)
////                            }
//                            if(followPath.count > idx + 1){
//                                nextNode = followPath[idx + 1]
//                                idx += 1
//                            }else{
//                                
//                            }
//                            
//                        }
//                        inPortal = false
////                        inPortalEntity = nil
//                    }else{
//                        inPortal = true
////                        inPortalEntity = (nextNode.suakeField.fieldEntity as! PortalEntity)
//                    }
//                }
//                let dx:Int32 = nextNode.gridPosition.x - Int32(curPos.x)
//                let dz:Int32 = nextNode.gridPosition.y - Int32(curPos.z)
//                let nextDir = PosHelper.getDirFromDif(dx: dx, dz: dz)
//                
//                suakeDirs.append(nextDir)
//                if(idx2 >= 1){
//                    nextTurnDir = SuakeDirTurnDirHelper.getTurnDirFromSuakeDirs(oldSuakeDir: suakeDirs[idx2 - 1], newSuakeDir: suakeDirs[idx2])
//                    if(nextTurnDir == .One80){
//                        nextTurnDir = .Straight
//                        break
//                    }
//                    turnDirs.append(nextTurnDir)
//                }
//                curPos.x += CGFloat(dx)
//                curPos.z += CGFloat(dz)
//                self.game.showDbgMsg(dbgMsg: "Opp-Move x: \(curPos.x) (\(dx)), z: \(curPos.z) (\(dz)), Dir: \(nextDir), Turn: \(nextTurnDir)", dbgLevel: .InfoOnlyConsole)
////                self.game.showDbgMsg(dbgMsg: "Opp-Move x: " + dx.description + " z: " + dz.description + " dir: " + nextDir.rawValue, dbgLevel: .InfoOnlyConsole)
//                
//                
//                
//                idx += 1
//                idx2 += 1
//            }
////            idx = 0
////            var nextTurnDir:TurnDir = .None
////            for suakeDir in suakeDirs{
////                if(idx >= 1){
////                    nextTurnDir = SuakeDirTurnDirHelper.getTurnDirFromSuakeDirs(oldSuakeDir: suakeDirs[idx - 1], newSuakeDir: suakeDirs[idx])
////                    if(nextTurnDir == .One80){
////                        nextTurnDir = .Straight
////                        break
////                    }
////                    turnDirs.append(nextTurnDir)
////                }
////                idx += 1
////            }
//            if(idx >= 1){
//                turnDirs.append(.Straight)
//            }
//            self.entity.turnQueue.removeAll()
//            for turn in turnDirs{
//                self.entity.turnQueue.append(turn)
//                self.game.showDbgMsg(dbgMsg: "Opp-Move turnDir: " + turn.rawValue, dbgLevel: .InfoOnlyConsole)
//            }
//        }
//    }
}
