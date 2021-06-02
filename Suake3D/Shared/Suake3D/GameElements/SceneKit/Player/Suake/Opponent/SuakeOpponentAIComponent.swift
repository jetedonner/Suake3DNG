//
//  SuakeOpponentAIComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit
import NetTestFW

class SuakeOpponentAIComponent: SuakeBaseComponent {
    
    
//    let seekGoody:OpponentSeekGoodyState
//
//    let seekMedKit:OpponentSeekMedKitState
//    let seekWeapon:OpponentSeekWeaponState
//    let stateMachine: GKStateMachine
    
    var stateMachine:SuakeOpponentStateMachine!
    
    var playerEntity:SuakeOppPlayerEntity{
        get{ return self.entity as! SuakeOppPlayerEntity }
    }
    
    var gridGraphHelper:GridGraphHelper!
    
    override init(game: GameController) {
        
        super.init(game: game)
    }

    override func didAddToEntity() {
        self.stateMachine = SuakeOpponentStateMachine(game: game, entity: self.entity as! SuakeOppPlayerEntity)
        self.gridGraphHelper = GridGraphHelper(game: game, playerEntity: self.entity as! SuakePlayerEntity)
        self.stateMachine.enter(OpponentSeekGoodyState.self)
    }
    
    func loadGridGraph(){
        self.gridGraphHelper.loadGridGraph()
    }
    
    var newPath:[SuakeGridGraphNode]!
    
    func findPath2Entity(entity:SuakeBasePlayerEntity, afterGoodyHit:Bool = false){
        let suakeEntity:SuakePlayerEntity = self.entity as! SuakePlayerEntity
        let daPos:SCNVector3 =  (afterGoodyHit ? suakeEntity.moveComponent.overNextPos : suakeEntity.pos)
        let vectPos2remove:[SCNVector3] = PositionHelper.getPos4DirNPosition(dir: suakeEntity.dir, relPos: [.One80, .Left, .Right], curPos: daPos)
        for vectPos in vectPos2remove {
            self.game.showDbgMsg(dbgMsg: "Removing Nodes around suake: \(daPos), node: \(vectPos)")
            self.gridGraphHelper.removeConnection(from: daPos, to: vectPos)
        }
        self.newPath = self.gridGraphHelper.findPathTo(entity: entity, afterGoodyHit: afterGoodyHit)
    }
    
    func followPathNG(){
        if(newPath != nil && newPath.count > 0){
            var curPos:SCNVector3 = self.playerEntity.pos
            var suakeDirs:[SuakeDir] = [SuakeDir]()
            var turnDirs:[TurnDir] = [TurnDir]()
            var idx = 0
            var idx2 = 0
            var nextTurnDir:TurnDir = .None
            var inPortal:Bool = false
            
            while idx < newPath.count {
                var nextNode = newPath[idx]
                if(nextNode.suakeField.fieldType == .portal){
                    if(inPortal){
                        if(newPath.count > idx + 1){
                            let portalEnd = nextNode
                            curPos.x = CGFloat((portalEnd.gridPosition.x))
                            curPos.z = CGFloat((portalEnd.gridPosition.y))
                            if(newPath.count > idx + 1){
                                nextNode = newPath[idx + 1]
                                idx += 1
                            }
                        }
                        inPortal = false
                    }else{
                        inPortal = true
                    }
                }
                let dx:Int32 = nextNode.gridPosition.x - Int32(curPos.x)
                let dz:Int32 = nextNode.gridPosition.y - Int32(curPos.z)
                let nextDir = PosHelper.getDirFromDif(dx: dx, dz: dz)
                
                suakeDirs.append(nextDir)
                
                if(idx2 >= 1){
                    nextTurnDir = SuakeDirTurnDirHelper.getTurnDirFromSuakeDirs(oldSuakeDir: suakeDirs[idx2 - 1], newSuakeDir: suakeDirs[idx2])
                    if(nextTurnDir == .One80){
                        nextTurnDir = .Straight
                        break
                    }
                    turnDirs.append(nextTurnDir)
                }
                curPos.x += CGFloat(dx)
                curPos.z += CGFloat(dz)
                self.game.showDbgMsg(dbgMsg: "Opp-Move x: \(curPos.x) (\(dx)), z: \(curPos.z) (\(dz)), Dir: \(nextDir), Turn: \(nextTurnDir)") //, dbgLevel: .InfoOnlyConsole)
                idx += 1
                idx2 += 1
            }
            if(idx >= 1){
                turnDirs.append(.Straight)
            }
            self.playerEntity.turnQueue.removeAll()
            for turn in turnDirs{
                self.playerEntity.turnQueue.append(turn)
                self.game.showDbgMsg(dbgMsg: "Opp-Move turnDir: " + String(reflecting: turn)) //, dbgLevel: .InfoOnlyConsole)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
