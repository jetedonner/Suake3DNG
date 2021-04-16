//
//  Crosshair.swift
//  Suake3D
//
//  Created by Kim David Hauser on 01.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class BaseCrosshairComponent: BaseExtHUDComponent {
    
    var inited:Bool = false
    var weaponType:WeaponType = .none
    
    var innerDist:CGFloat = 19.0
    var outerDist:CGFloat = 29.0
    
    var notAimedAtColor:SKColor = SKColor.orange
    var aimedAtColor:SKColor = SKColor.green
    var unavailableColor:SKColor = SKColor.red
    
    var currentColor:SKColor = SKColor.orange
    var oldColor:SKColor = SKColor.green
    
    var centerPoint:CGPoint = CGPoint(x: 0, y: 0)
    
    var animSpeed:Float = 0.34
    var animTime:TimeInterval = 0.15
    var animationOut:Bool = true
    var animatedIn:Bool = false
    
    var animCS:Bool = false
    
    var _unavailable:Bool = false
    var unavailable:Bool{
        get{ return self._unavailable }
        set{
            if(self.unavailable != newValue){
                self._unavailable = newValue
                if(self.unavailable){
                    self.oldColor = self.currentColor
                    self.currentColor = self.unavailableColor
                }else{
                    self.currentColor = self.oldColor
                }
            }
        }
    }
    
    let nodeCrosshairShapes:SKShapeNode = SKShapeNode()
 
    init(game:GameController, weaponType:WeaponType) {
        super.init(game: game)
        self.weaponType = weaponType
        self.isHidden = true
    }
    
    func animateCrosshair(){
        self.animationOut = !self.animationOut
        self.animateCrosshair(animated: self.animationOut)
    }
    
    func animateCrosshair(animated:Bool){
        
    }
    
    @discardableResult
    func drawAndGetCrosshair()->SKSpriteNode{
        if(!self.inited){
            self.inited = true
        }
        return self.nodeContainer
    }

    func drawStrokePath(from:CGPoint, to:CGPoint)->CGMutablePath{
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        path.closeSubpath()
        return path
    }
    
    func createShapeFromPath(path:CGMutablePath)->SKShapeNode{
        let shapeNode = SKShapeNode()
        shapeNode.isAntialiased = false
        shapeNode.lineWidth = 1.0
        shapeNode.path = path
        shapeNode.strokeColor = self.currentColor
        self.nodeCrosshairShapes.addChild(shapeNode)
        return shapeNode
    }
    
    var aimedAtPointDistX:CGFloat = 17.0
    var aimedAtPointDistY:CGFloat = 70.0
    
    func checkAimedAtPoint(point:SCNVector3)->Bool{
        let tmpPoint = self.game.scnView.projectPoint(point)
        if(tmpPoint.x >= (self.game.gameWindowSize.width / 2) - self.aimedAtPointDistX && tmpPoint.x <= (self.game.gameWindowSize.width / 2) + self.aimedAtPointDistX && tmpPoint.y >= (self.game.gameWindowSize.height / 2) - self.aimedAtPointDistY && tmpPoint.y <= (self.game.gameWindowSize.height / 2) + self.aimedAtPointDistY && tmpPoint.z < 1.0){
            return true
        }else{
            return false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
