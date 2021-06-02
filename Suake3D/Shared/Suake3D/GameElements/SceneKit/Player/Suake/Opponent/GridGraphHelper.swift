//
//  GridGraphHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class GridGraphHelper:SuakeGameClass{
    
//    let playerType:SuakePlayerType
    let playerEntity:SuakeBasePlayerEntity
    var gridGraph:GKGridGraph<SuakeGridGraphNode>!
    
    init(game:GameController, removeOwn:Bool = true, playerEntity:SuakeBasePlayerEntity) {
        self.playerEntity = playerEntity
        super.init(game: game)
    }
    
    func removeConnection(from:SCNVector3, to:SCNVector3){
//        let daNode:GKGridGraphNode? = self.game.gridGraphManager.gridGraphHelper.gridGraph.node(atGridPosition: vector_int2(Int32(from.x), Int32(from.z)))
        let daNode:GKGridGraphNode? = self.gridGraph.node(atGridPosition: vector_int2(Int32(from.x), Int32(from.z)))
        if(daNode != nil){
            self.gridGraph.node(atGridPosition: vector_int2(Int32(to.x), Int32(to.z)))?.removeConnections(to: [daNode!], bidirectional: true)
        }
    }
    
    func loadGridGraph(removeOwn:Bool = true){
        var nodes = [SuakeGridGraphNode]()
        
        let endI:Int32 = Int32(self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize().width / 2)
        let startI:Int32 = -endI
        
        let endJ:Int32 = Int32(self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize().height / 2)
        let startJ:Int32 = -endJ
        
        for i in startI..<endI {
            for j in startJ..<endJ {
                let fieldPos:SCNVector3 = SCNVector3(CGFloat(i), 0, CGFloat(j))
                let tmp = self.game.levelManager.gameBoard.getGameBoardField(pos: fieldPos)
                let tmp2 = self.game.levelManager.gameBoard.getGameBoardFieldItem(pos: fieldPos)
                let node = SuakeGridGraphNode(game: self.game, gridPosition: vector_int2(Int32(i), Int32(j)), suakeFieldType: tmp, fieldEntity: tmp2)
                nodes.append(node)
            }
        }
        
        self.gridGraph = GKGridGraph(fromGridStartingAt: vector_int2(x: startI, y: startJ), width: endI * 2, height: endJ * 2, diagonalsAllowed:false, nodeClass: SuakeGridGraphNode.self)
        
        for node in nodes{
            if let existingNode = self.gridGraph.node(atGridPosition: node.gridPosition) {
                self.gridGraph.remove([existingNode])
            }
            self.gridGraph.connectToAdjacentNodes(node: node)
        }
    }
    
    let maxLoop:Int = 2000
    var route = [SuakeGridGraphNode]()
    var tmpIdx:Int = 0
    
    func findPathTo(entity:SuakeBasePlayerEntity, afterGoodyHit:Bool = false)->[SuakeGridGraphNode]{
        self.tmpIdx += 1
        let fromPos:SCNVector3 = (afterGoodyHit ? /*(tmpIdx == 3 ? self.playerEntity.pos :*/ (self.playerEntity as! SuakeOppPlayerEntity).moveComponent.overNextPos/*)*/ : self.playerEntity.pos)
        let toPos:SCNVector3 = entity.pos
        self.game.showDbgMsg(dbgMsg: "FindPath => fromPos: \(fromPos) -> toPos: \(toPos)")
        return self.findPathFromTo(posFrom: fromPos, posTo: toPos)
    }
    
    func findPathFromTo(posFrom:SCNVector3, posTo:SCNVector3, doNotRemoveFirst:Bool = false)->[SuakeGridGraphNode]{
        if let currentNode = gridGraph.node(atGridPosition: SIMD2<Int32>(x: Int32(posFrom.x), y: Int32(posFrom.z))){
            
            var currLoop:Int = 0
            
            repeat{
                if let destinationNode = gridGraph.node(atGridPosition: SIMD2<Int32>(x: Int32(posTo.x), y: Int32(posTo.z))){
                    if let path = gridGraph.findPath(from: currentNode, to: destinationNode) as? [SuakeGridGraphNode]{
                        route = path
                    } else {
                        fatalError("Got a very unexpected output from findpath")
                    }
                }
                if route.count > 0 && !doNotRemoveFirst {
                    route.remove(at: 0)
                }
                currLoop += 1
            } while route.count == 0 && currLoop <= maxLoop
            
            for node in route{
//                print("PATH-NODE: \(node.gridPosition)")
                self.game.showDbgMsg(dbgMsg: "PATH-NODE: \(node.gridPosition)")
            }
            return route
        }else{
            self.game.showDbgMsg(dbgMsg: "Error in finding findPathFromTo() > currentNode == nil, posFrom: \(posFrom), posTo: \(posTo)")
            return []
        }
    }
}
