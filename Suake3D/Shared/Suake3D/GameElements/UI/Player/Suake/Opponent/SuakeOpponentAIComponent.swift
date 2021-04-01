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

class SuakeOpponentAIComponent: SuakeBaseComponent {
    
    var playerEntity:SuakeOppPlayerEntity{
        get{ return self.entity as! SuakeOppPlayerEntity }
    }
    
    var gridGraphHelper:GridGraphHelper!
    
    override init(game: GameController) {
        super.init(game: game)
    }

    override func didAddToEntity() {
        self.gridGraphHelper = GridGraphHelper(game: game, playerEntity: self.entity as! SuakePlayerEntity)
    }
    
    func loadGridGraph(){
        self.gridGraphHelper.loadGridGraph()
    }
    
    var newPath:[SuakeGridGraphNode]!
    
    func findPath2Entity(entity:SuakeBasePlayerEntity){
        self.newPath = self.gridGraphHelper.findPathTo(entity: entity)
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
                self.game.showDbgMsg(dbgMsg: "Opp-Move x: \(curPos.x) (\(dx)), z: \(curPos.z) (\(dz)), Dir: \(nextDir), Turn: \(nextTurnDir)", dbgLevel: .InfoOnlyConsole)
                idx += 1
                idx2 += 1
            }
            if(idx >= 1){
                turnDirs.append(.Straight)
            }
            self.playerEntity.turnQueue.removeAll()
            for turn in turnDirs{
                self.playerEntity.turnQueue.append(turn)
                self.game.showDbgMsg(dbgMsg: "Opp-Move turnDir: " + turn.rawValue, dbgLevel: .InfoOnlyConsole)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
