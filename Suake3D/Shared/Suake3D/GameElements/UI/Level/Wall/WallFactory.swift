//
//  WallFactory.swift
//  Suake3D
//
//  Created by Kim David Hauser on 22.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class WallFactory: SuakeGameClass {
    
    var wallGrp:SCNNode = SCNNode()
    var wallGrpUpper:SCNNode = SCNNode()
    var wallGrpLower:SCNNode = SCNNode()
    var wallGrpLeft:SCNNode = SCNNode()
    var wallGrpRight:SCNNode = SCNNode()
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func loadWall(initialLoad:Bool = true){
        if(initialLoad && self.wallGrp.parent != nil){
            self.wallGrp.removeFromParentNode()
        }
        self.wallGrp = SCNNode()
        self.wallGrpUpper = SCNNode()
        self.wallGrpLower = SCNNode()
        self.wallGrpLeft = SCNNode()
        self.wallGrpRight = SCNNode()
        
        let fieldSize:CGFloat = SuakeVars.fieldSize
        let fieldSizeHalf:CGFloat = fieldSize / 2
        
        let wallWidth:CGFloat = SuakeVars.wallWidth
        let wallHalftWidth:CGFloat = wallWidth / 2
        
        let wallPartsWidth:CGFloat = ((fieldSize / wallWidth) * (self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize().width + 1))
        
        let wallNodeOrig:SCNNode = self.initOneWallNode(wallWidth: wallWidth, wallHeight: wallWidth, wallHalfWidth: wallHalftWidth)
        
        let wallNodeOrigHalfWidth:SCNNode = self.initOneWallNodeHalfWidth(wallWidth: wallWidth / 2, wallHeight: wallWidth, wallHalfWidth: wallHalftWidth)
        
        wallGrp = SCNNode()
        let offsetWall:CGFloat = wallHalftWidth + (wallHalftWidth / 2) + fieldSizeHalf
        
        let left:CGFloat = CGFloat(self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize().width * fieldSize / 2)
        
        let rotationWall:SCNVector4 = SCNVector4(x: CGFloat(0), y: CGFloat(1), z: CGFloat(0), w: CGFloat(Double.pi / 2.0))
        
        for i in (0..<Int(wallPartsWidth)){
            
            let newWallNodeUpper:SCNNode = wallNodeOrig.clone() as SCNNode
            newWallNodeUpper.name = "WallNode (Upper) No. " + i.description
            newWallNodeUpper.position.x = -left + (CGFloat(i) * wallWidth) - offsetWall
            newWallNodeUpper.position.z = CGFloat((wallPartsWidth) * wallWidth / 2) - fieldSizeHalf
            wallGrpUpper.addChildNode(newWallNodeUpper)
            
            let newWallNodeLower:SCNNode = wallNodeOrig.clone() as SCNNode
            newWallNodeLower.name = "WallNode (Lower) No. " + i.description
            newWallNodeLower.position.x = -left + (CGFloat(i) * wallWidth) - offsetWall
            newWallNodeLower.position.z = CGFloat((wallPartsWidth) * wallWidth / -2) - fieldSizeHalf
            wallGrpLower.addChildNode(newWallNodeLower)
            
            let newWallNodeLeft:SCNNode = wallNodeOrig.clone() as SCNNode
            newWallNodeLeft.name = "WallNode (Left) No. " + i.description
            newWallNodeLeft.position.x = left
            newWallNodeLeft.position.z = -left + (CGFloat(i) * wallWidth) - offsetWall
            newWallNodeLeft.rotation = rotationWall
            wallGrpLeft.addChildNode(newWallNodeLeft)
            
            let newWallNodeRight:SCNNode = wallNodeOrig.clone() as SCNNode
            newWallNodeRight.name = "WallNode (Right) No. " + i.description
            newWallNodeRight.position.x = -left - fieldSize
            newWallNodeRight.position.z = -left + (CGFloat(i) * wallWidth) - offsetWall
            newWallNodeRight.rotation = rotationWall
            wallGrpRight.addChildNode(newWallNodeRight)
            
            if(i == Int(wallPartsWidth-1)){
                
                let newWallNodeUpperEnd:SCNNode = wallNodeOrigHalfWidth.clone() as SCNNode
                newWallNodeUpperEnd.name = "WallNode (Upper - END) No. " + i.description
                newWallNodeUpperEnd.position.x = -left + (CGFloat(i + 1) * wallWidth) - offsetWall - (wallHalftWidth / 2)
                newWallNodeUpperEnd.position.z = CGFloat((wallPartsWidth) * wallWidth / 2) - fieldSizeHalf
                wallGrpUpper.addChildNode(newWallNodeUpperEnd)
                
                let newWallNodeLowerEnd:SCNNode = wallNodeOrigHalfWidth.clone() as SCNNode
                newWallNodeLowerEnd.name = "WallNode (Lower - END) No. " + i.description
                newWallNodeLowerEnd.position.x = -left + (CGFloat(i + 1) * wallWidth) - offsetWall - (wallHalftWidth / 2)
                newWallNodeLowerEnd.position.z = CGFloat((wallPartsWidth) * wallWidth / -2) - fieldSizeHalf
                wallGrpLower.addChildNode(newWallNodeLowerEnd)
                
                let newWallNodeLeftEnd:SCNNode = wallNodeOrigHalfWidth.clone() as SCNNode
                newWallNodeLeftEnd.name = "WallNode (Left - END) No. " + i.description
                newWallNodeLeftEnd.position.x = left
                newWallNodeLeftEnd.position.z = -left + (CGFloat(i + 1) * wallWidth) - offsetWall - (wallHalftWidth / 2)
                newWallNodeLeftEnd.rotation = rotationWall
                wallGrpLeft.addChildNode(newWallNodeLeftEnd)
                
                let newWallNodeRightEnd:SCNNode = wallNodeOrigHalfWidth.clone() as SCNNode
                newWallNodeRightEnd.name = "WallNode (Right - END) No. " + i.description
                newWallNodeRightEnd.position.x = -left - fieldSize
                newWallNodeRightEnd.position.z = -left + (CGFloat(i + 1) * wallWidth) - offsetWall - (wallHalftWidth / 2)
                newWallNodeRightEnd.rotation = rotationWall
                wallGrpRight.addChildNode(newWallNodeRightEnd)
            }
        }
        
        self.addWallToScene()
    }
    
    func initOneWallNode(wallWidth:CGFloat, wallHeight:CGFloat, wallHalfWidth:CGFloat)->SCNNode{
        let wallBoxGeometry:SCNBox = SCNBox(width: wallWidth, height: wallWidth, length: 20.0, chamferRadius: 1.0)
        let plainPlaneGeometry = SCNPlane(width: wallWidth, height: wallHeight)
        plainPlaneGeometry.firstMaterial?.diffuse.contents = NSImage(named: .wall)
        plainPlaneGeometry.firstMaterial?.lightingModel = .constant
        plainPlaneGeometry.firstMaterial?.isDoubleSided = true
        let plainPlane1 = SCNNode(geometry: plainPlaneGeometry)
        plainPlane1.position = SCNVector3Make(0, wallHalfWidth, 0)
        
        self.addPhysicsBody(geometry: wallBoxGeometry, node: plainPlane1)
        plainPlane1.categoryBitMask = CollisionCategory.wall.rawValue
        return plainPlane1
    }
    
    func initOneWallNodeHalfWidth(wallWidth:CGFloat, wallHeight:CGFloat, wallHalfWidth:CGFloat)->SCNNode{
        let wallBoxGeometry:SCNBox = SCNBox(width: wallWidth, height: wallWidth, length: 20.0, chamferRadius: 1.0)
        let plainPlaneGeometry = SCNPlane(width: wallWidth, height: wallHeight)
        plainPlaneGeometry.firstMaterial?.diffuse.contents = NSImage(named: .wallHalf)
        plainPlaneGeometry.firstMaterial?.lightingModel = .constant
        plainPlaneGeometry.firstMaterial?.isDoubleSided = true
        let plainPlane1 = SCNNode(geometry: plainPlaneGeometry)
        plainPlane1.position = SCNVector3Make(0, wallHalfWidth, 0)
        
        self.addPhysicsBody(geometry: wallBoxGeometry, node: plainPlane1)
        plainPlane1.categoryBitMask = CollisionCategory.wall.rawValue
        return plainPlane1
    }
    
    func addPhysicsBody(geometry:SCNGeometry, node:SCNNode){
        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        node.physicsBody?.isAffectedByGravity = false
        node.physicsBody?.categoryBitMask = CollisionCategory.wall.rawValue
        node.physicsBody?.contactTestBitMask = CollisionCategory.mgbullet.rawValue | CollisionCategory.pellet.rawValue | CollisionCategory.rocket.rawValue | CollisionCategory.railbeam.rawValue
        node.physicsBody?.collisionBitMask = 0
    }
    
    func addWallToScene(){
        wallGrp.name = "WallGroup"
        wallGrpUpper.name = "WallGroup-Upper"
        wallGrpLower.name = "WallGroup-Lower"
        wallGrpLeft.name = "WallGroup-Left"
        wallGrpRight.name = "WallGroup-Right"
        wallGrp.addChildNode(wallGrpUpper)
        wallGrp.addChildNode(wallGrpLower)
        wallGrp.addChildNode(wallGrpLeft)
        wallGrp.addChildNode(wallGrpRight)
        self.game.physicsHelper.qeueNode2Add2Scene(node: wallGrp)
    }
}
