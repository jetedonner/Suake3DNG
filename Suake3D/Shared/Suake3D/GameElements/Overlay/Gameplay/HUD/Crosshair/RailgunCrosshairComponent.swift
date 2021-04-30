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

class RailgunCrosshairComponent: BaseCrosshairComponent {

    let nodeCrosshairStrokes:SKShapeNode = SKShapeNode()
    let nodeCrosshairPies:SKShapeNode = SKShapeNode()
    var nodeCrosshairCircle:SKShapeNode = SKShapeNode()
    
    var strokeNodes:[SKShapeNode] = [SKShapeNode]()
    var pieNodes:[SKShapeNode] = [SKShapeNode]()
    
    let lastPieAnimateDelay:TimeInterval = 0.15
    let pieAnimateDistance:CGFloat = 5.0
    
    init(game:GameController) {
        super.init(game: game, weaponType: .railgun)
        self.animTime = 0.07
        self.innerDist = 9.0
        self.outerDist = 19.0
    }
    
    override func animateCrosshair(animated:Bool){
        self.animationOut = animated
        self.animateStrokes(animated: animated)
        self.animatePies(animated: animated)
        
//        if(DbgVars.playAimingSounds){
//            if(!animated){
//                self.game.audioManager.playSound(soundType: .railgunAimed)
//            }else{
//                self.game.audioManager.playSound(soundType: .railgunUnaimed)
//            }
//        }
    }
    
    func animateStrokes(animated:Bool){
        var idx:Int = 0
        for stroke in self.strokeNodes{
            if(idx <= 1){
                stroke.run(SKAction.scaleX(to: (animated ? 1.0 : 1.15), y: 1.0, duration: self.animTime))
            }else{
                stroke.run(SKAction.scaleX(to: 1.0, y: (animated ? 1.0 : 1.15), duration: self.animTime))
            }
            idx += 1
        }
    }
    
    func animatePies(animated:Bool){
        var idx:Int = 0
        let mult:CGFloat = (animated ? 0.0 : -1.0)
        for pie in self.pieNodes{
            pie.removeAllActions()
            pie.run(SKAction.scale(to: (animated ? 1.0 : 0.65), duration: self.animTime))
            if(idx == 0){
                pie.run(SKAction.move(to: CGPoint(x: self.pieDistance + (mult * self.pieAnimateDistance), y: self.pieDistance + (mult * self.pieAnimateDistance)), duration: self.animTime))
            }else if(idx == 1){
                pie.run(SKAction.move(to: CGPoint(x: -self.pieDistance - (mult * self.pieAnimateDistance), y: self.pieDistance + (mult * self.pieAnimateDistance)), duration: self.animTime))
            }else if(idx == 2){
                pie.run(SKAction.move(to: CGPoint(x: -self.pieDistance - (mult * self.pieAnimateDistance), y: -self.pieDistance - (mult * self.pieAnimateDistance)), duration: self.animTime))
            }else if(idx == 3){
                pie.run(SKAction.sequence([SKAction.wait(forDuration: self.lastPieAnimateDelay * (animated ? 0 : 1)), SKAction.move(to: CGPoint(x: self.pieDistance + (mult * self.pieAnimateDistance), y: -self.pieDistance - (mult * self.pieAnimateDistance)), duration: self.animTime * (animated ? 1 : 1.5))]), completion: {
                    for stroke in self.strokeNodes{
                        stroke.strokeColor = (animated || self.animationOut ? self.notAimedAtColor : self.aimedAtColor)
                    }
                
                    for pie in self.pieNodes{
                        pie.strokeColor = (animated || self.animationOut ? self.notAimedAtColor : self.aimedAtColor)
                        pie.fillColor = (animated || self.animationOut ? self.notAimedAtColor : self.aimedAtColor)
                    }
                    self.nodeCrosshairCircle.isHidden = animated || self.animationOut
                    self.nodeCrosshairCircle.strokeColor = (animated || self.animationOut ? self.notAimedAtColor : self.aimedAtColor)
                    self.game.showDbgMsg(dbgMsg: ".animatePies(" + animated.description + "), .animationOut = " + self.animationOut.description, dbgLevel: .Verbose)
                })
            }
            idx += 1
        }
    }
    
    override func drawAndGetCrosshair()->SKSpriteNode{
        self.drawStrokePaths()
        self.drawPiePaths()
        self.createCenterCircle()
        return super.drawAndGetCrosshair()
    }
    
    
    func createCenterCircle(){
        self.nodeCrosshairCircle = SKShapeNode(circleOfRadius: 1.0)
        self.nodeCrosshairCircle.position = CGPoint(x: 0, y: 0)
        self.nodeCrosshairCircle.strokeColor = self.notAimedAtColor
        self.nodeCrosshairCircle.lineWidth = 1.0
        self.nodeCrosshairCircle.isAntialiased = false
        self.nodeCrosshairCircle.isHidden = true
        self.nodeContainer.addChild(self.nodeCrosshairCircle)
    }
    
    
    let pieRadius:CGFloat = 10.0
    let pieDistance:CGFloat = 15.0
    
    func createPieShape(x:CGFloat, y:CGFloat, startAngle:CGFloat, endAngle:CGFloat)->SKShapeNode{
        let shapeNode:SKShapeNode = SKShapeNode()
        shapeNode.fillColor = self.notAimedAtColor
        shapeNode.strokeColor = self.notAimedAtColor
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addArc(center: CGPoint.zero, radius: self.pieRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        shapeNode.path = path
        shapeNode.position.x = x
        shapeNode.position.y = y
        nodeCrosshairPies.addChild(shapeNode)
        return shapeNode
    }
    
    
    func drawPiePaths(){
        let sliceAngel:CGFloat = CGFloat(Float.pi) / 6
        
        // NE - (UP / RIGHT) 0
        self.pieNodes.append(self.createPieShape(x: self.pieDistance, y: self.pieDistance, startAngle: sliceAngel, endAngle: sliceAngel * 2))
        
        // NW - (UP / LEFT) 1
        self.pieNodes.append(self.createPieShape(x: -self.pieDistance, y: self.pieDistance, startAngle: sliceAngel * 4, endAngle: sliceAngel * 5))
        
        // SW - (DOWN / LEFT) 2
        self.pieNodes.append(self.createPieShape(x: -self.pieDistance, y: -self.pieDistance, startAngle: sliceAngel * 7, endAngle: sliceAngel * 8))
        
        // SE - (DOWN / RIGHT) 3
        self.pieNodes.append(self.createPieShape(x: self.pieDistance, y: -self.pieDistance, startAngle: sliceAngel * 10, endAngle: sliceAngel * 11))
        
        self.nodeContainer.addChild(self.nodeCrosshairPies)
    }
    
    func drawStrokePaths(){
        
        // RIGHT 0
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x + innerDist, y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x + outerDist, y: self.centerPoint.y))))
        
        // LEFT 1
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - innerDist, y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x - outerDist, y: self.centerPoint.y))))

        // DOWN 2
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - innerDist), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - outerDist))))

        // UP 3
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + innerDist), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + outerDist))))
        
        self.nodeContainer.addChild(self.nodeCrosshairShapes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
