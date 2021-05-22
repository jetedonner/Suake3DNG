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

class ShotgunCrosshairComponent: BaseCrosshairComponent {

    var nodeCrosshairCenterCircle:SKShapeNode = SKShapeNode()
    var nodeCrosshairCircle:SKShapeNode = SKShapeNode()
    var strokeNodes:[SKShapeNode] = [SKShapeNode]()
    
    override var unavailable:Bool{
        get{ return super.unavailable }
        set{
            super.unavailable = newValue
            self.nodeCrosshairCenterCircle.strokeColor = self.currentColor
            self.nodeCrosshairCircle.strokeColor = self.currentColor
            for strokeNode in self.strokeNodes{
                strokeNode.strokeColor = self.currentColor
            }
        }
    }
    
    init(game:GameController) {
        super.init(game: game, weaponType: .shotgun)
        self.animTime = 0.12
        
        self.innerDist = 09.0
        self.outerDist = 19.0
    }
    
    override func animateCrosshair(animated:Bool){
        self.animationOut = animated
        self.animateStrokes(animated: animated)
        
//        if(DbgVars.playAimingSounds){
//            if(!animated){
//                self.game.audioManager.playSound(soundType: .shotgunAimed)
//            }
//        }
    }
    
    func animateStrokes(animated:Bool){
        var idx:Int = 0
        for stroke in self.strokeNodes{
            if(idx <= 1){
                stroke.run(SKAction.scaleX(to: (animated ? 0.0 : 1.0), duration: self.animTime))
            }else{
                stroke.run(SKAction.scaleY(to: (animated ? 0.0 : 1.0), duration: self.animTime))
            }
//            if(!animated){
//                stroke.isHidden = animated
//            }
            stroke.strokeColor = (animated ? self.notAimedAtColor : self.aimedAtColor)
            idx += 1
        }
        self.nodeCrosshairCircle.strokeColor = (animated ? self.notAimedAtColor : self.aimedAtColor)
        self.nodeCrosshairCenterCircle.isHidden = !animated
    }
    
    override func drawAndGetCrosshair()->SKSpriteNode{
        self.drawStrokePaths()
        self.createCenterCircle()
        self.createCircle()
        return super.drawAndGetCrosshair()
    }
    
    
    func createCenterCircle(){
        self.nodeCrosshairCenterCircle = SKShapeNode(circleOfRadius: 1.0)
        self.nodeCrosshairCenterCircle.position = CGPoint(x: 0, y: 0)
        self.nodeCrosshairCenterCircle.strokeColor = self.notAimedAtColor
        self.nodeCrosshairCenterCircle.lineWidth = 1.0
        self.nodeCrosshairCenterCircle.isAntialiased = false
        self.nodeContainer.addChild(self.nodeCrosshairCenterCircle)
    }
    
    func createCircle(){
        self.nodeCrosshairCircle = SKShapeNode(circleOfRadius: 15.0)
        self.nodeCrosshairCircle.position = CGPoint(x: 0, y: 0)
        self.nodeCrosshairCircle.strokeColor = self.notAimedAtColor
        self.nodeCrosshairCircle.lineWidth = 1.0
//        self.nodeCrosshairCircle.glowWidth = 2.0
        self.nodeCrosshairCircle.isAntialiased = false
        self.nodeContainer.addChild(self.nodeCrosshairCircle)
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
        
        var idx:Int = 0
        for stroke in self.strokeNodes{
            if(idx <= 1){
                stroke.xScale = 0.0
            }else{
                stroke.yScale = 0.0
            }
            idx += 1
        }
        
        self.nodeContainer.addChild(self.nodeCrosshairShapes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
