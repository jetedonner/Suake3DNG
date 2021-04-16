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

class RPGCrosshairComponent: BaseCrosshairComponent {

    let nodeCrosshairStrokes:SKShapeNode = SKShapeNode()
    
    var strokeNodes:[SKShapeNode] = [SKShapeNode]()
    var arcNodes:[SKShapeNode] = [SKShapeNode]()
    var arcNode:SKShapeNode!

    var nodeCrosshairCircle:SKShapeNode = SKShapeNode()
    
    init(game:GameController) {
        super.init(game: game, weaponType: .rpg)
        
        self.animTime = 0.17
        
        self.innerDist = 7.0
        self.outerDist = 15.0
    }
    
    override func animateCrosshair(animated:Bool){
        self.animationOut = animated
        self.animateArcParts(animated: animated)
    }
    
    func animateArcParts(animated:Bool){
        self.nodeContainer.run(SKAction.rotate(byAngle: CGFloat.pi * (animated ? -1 : 1), duration: self.animTime))
        
        for arcNode in self.arcNodes{
            arcNode.strokeColor = (animated ? self.notAimedAtColor : self.aimedAtColor)
            arcNode.run(SKAction.scale(to: (animated ? 1.0 : 0.5), duration: self.animTime))
        }
        
        self.nodeCrosshairCircle.strokeColor = (animated ? self.notAimedAtColor : self.aimedAtColor)
        self.nodeCrosshairCircle.run(SKAction.scale(to: (animated ? 1.0 : 0.15), duration: self.animTime), completion: {
            if(!animated && !self.animationOut){
                self.nodeCrosshairCircle.fillColor = self.aimedAtColor
            }
        })
        
        if(animated){
            self.nodeCrosshairCircle.fillColor = .clear
        }
    }
    
//    var inited:Bool = false
    
    @discardableResult
    override func drawAndGetCrosshair()->SKSpriteNode{
//        inited = true
        self.createArcs()
        self.createCircle()
        return super.drawAndGetCrosshair()
    }
    
    
    func createArcs(){
        self.addArcPart(startAngle: 20, endAngle: 70)
        self.addArcPart(startAngle: 110, endAngle: 160)
        self.addArcPart(startAngle: 200, endAngle: 250)
        self.addArcPart(startAngle: 290, endAngle: 340)
    }
    
    func addArcPart(startAngle:CGFloat, endAngle:CGFloat){
        let path:NSBezierPath = NSBezierPath()
        path.appendArc(withCenter: CGPoint(x: 0.0,y: 0.0), radius: 20.0, startAngle: startAngle, endAngle: endAngle)
        path.stroke()
        
        let newShapeNode:SKShapeNode =  SKShapeNode(path: path.cgPath)
        newShapeNode.strokeColor = .orange
        newShapeNode.lineWidth = 2.0
        newShapeNode.isAntialiased = false
        self.arcNodes.append(newShapeNode)
        self.nodeContainer.addChild(newShapeNode)
    }
    
    func createCircle(){
        self.nodeCrosshairCircle = SKShapeNode(circleOfRadius: 8.0)
        self.nodeCrosshairCircle.position = CGPoint(x: 0, y: 0)
        self.nodeCrosshairCircle.strokeColor = self.notAimedAtColor
        self.nodeCrosshairCircle.lineWidth = 1.0
        self.nodeCrosshairCircle.isAntialiased = false
        self.nodeContainer.addChild(self.nodeCrosshairCircle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
