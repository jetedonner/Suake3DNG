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

class DroidAIComponent: SuakeBaseComponent {
    
    var playerEntity:DroidEntity{
        get{ return self.entity as! DroidEntity }
    }
    
//    var gridGraphHelper:GridGraphHelper!
    
    override init(game: GameController) {
        super.init(game: game)
    }

    override func didAddToEntity() {
//        self.gridGraphHelper = GridGraphHelper(game: game, playerEntity: self.entity as! SuakePlayerEntity)
    }
    
    func loadGridGraph(){
//        self.gridGraphHelper.loadGridGraph()
    }
    
    var newPath:[SuakeGridGraphNode]!
    
    func findPath2Entity(entity:SuakeBasePlayerEntity){
        self.newPath = self.game.gridGraphManager.findPath(fromEntity: self.playerEntity, toEntity: entity)
    }
    
    @discardableResult
    func followPath()->Bool{
        if(self.newPath != nil && self.newPath.count > 0){
//            (self.entity as! DroidEntity).droidComponent.changeDroidMode(state: .Chasing)
            let nextGridNode:GKGridGraphNode = self.newPath[0]
//            let ownOverNextPos:SCNVector3 = self.overNextPosNG
//            for otherDroids in self.game.playerEntityManager.otherDroids(excludeDroid: self.entity as! DroidEntity){
//                if(otherDroids.followComponent.overNextPosNG == self.overNextPosNG){
//                    (self.entity as! DroidEntity).followComponent.loadPath(toEntity: self.followEntity)
////                    self.followPath()
//                    return false
//                }
//            }
            
//            if(self.path.count > 1){
//                let overNextGridNode:GKGridGraphNode = self.path[1]
//                self.overNextPos = SCNVector3(Int(overNextGridNode.gridPosition.x), 0, Int(overNextGridNode.gridPosition.y))
//            }
            let nextNodeVect:SCNVector3 = SCNVector3(Int(nextGridNode.gridPosition.x), 0, Int(nextGridNode.gridPosition.y))
            
            let dx:Int = Int(nextNodeVect.x - (self.entity as! SuakeBaseNodeEntity).pos.x)
            let dz:Int = Int(nextNodeVect.z - (self.entity as! SuakeBaseNodeEntity).pos.z)
            
            var hasMoved:Bool = false
            if let droidComponent = (self.entity as! DroidEntity).component(ofType: DroidComponent.self){
                if(dx != 0){
                    if(dx > 0){
                        hasMoved = droidComponent.nextMove(newDir: .LEFT)
                    }else{
                        hasMoved = droidComponent.nextMove(newDir: .RIGHT)
                    }
                }else if(dz != 0){
                    if(dz > 0){
                        hasMoved = droidComponent.nextMove(newDir: .UP)
                    }else{
                        hasMoved = droidComponent.nextMove(newDir: .DOWN)
                    }
                }
            }
            if(hasMoved){
                self.newPath.remove(at: 0)
            }
        }else{
            if let droidComponent = (self.entity as! DroidEntity).component(ofType: DroidComponent.self){
                (droidComponent.node as! SuakeBaseMultiAnimatedSCNNode).getAnimPlayer()!.stop()
            }
        }
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
