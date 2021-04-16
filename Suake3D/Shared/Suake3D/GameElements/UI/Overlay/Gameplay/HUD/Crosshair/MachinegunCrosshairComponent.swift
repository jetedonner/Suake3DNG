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

class MachinegunCrosshairComponent: BaseCrosshairComponent {

//    var inited:Bool = false
    let nodeCrosshairStrokes:SKShapeNode = SKShapeNode()
    
    var strokeNodes:[SKShapeNode] = [SKShapeNode]()
    var arcNode:SKShapeNode!
    
    let path1:NSBezierPath = NSBezierPath()
    let path2:NSBezierPath = NSBezierPath()
    
    override var unavailable:Bool{
        get{ return super.unavailable }
        set{
            super.unavailable = newValue
            self.arcNode.strokeColor = self.currentColor
            for strokeNode in self.strokeNodes{
                strokeNode.strokeColor = self.currentColor
            }
        }
    }
    
    init(game:GameController) {
        super.init(game: game, weaponType: .mg)
        
        self.animTime = 0.12
        
        self.innerDist = 7.0
        self.outerDist = 15.0
    }
    
    override func animateCrosshair(animated:Bool){
        if(self.unavailable){
            self.currentColor = self.unavailableColor
            self.oldColor = (animated ? self.notAimedAtColor : self.aimedAtColor)
        }else{
            self.currentColor = (animated ? self.notAimedAtColor : self.aimedAtColor)
        }
        self.currentColor = (self.unavailable ? self.unavailableColor : (animated ? self.notAimedAtColor : self.aimedAtColor))
        self.animationOut = animated
        self.animateStrokes(animated: animated)
        self.animateArc(animated: animated)
    }
    
    func animateStrokes(animated:Bool){
        var idx:Int = 0
        for stroke in self.strokeNodes{
            if(idx == 2){
                stroke.run(SKAction.scale(to: (animated ? 1.0 : 1.25), duration: self.animTime))
                stroke.run(SKAction.scaleY(to: (animated ? 1.0 : 2.1), duration: self.animTime))
                stroke.run(SKAction.move(to: CGPoint(x: 0, y: (animated ? downStrokeY - 4 : downStrokeY + 9)), duration: self.animTime))
                
            }
            stroke.strokeColor = self.currentColor
            idx += 1
        }
    }
    
    func animateArc(animated:Bool){
        self.arcNode.run(SKAction.customAction(withDuration: self.animTime, actionBlock: { (node, timeDuration) in
            
            let dur:TimeInterval = Double(timeDuration)
            let percent:Double = dur / self.animTime
            let newPath:NSBezierPath = NSBezierPath()
            if(animated){
                newPath.appendArc(withCenter: CGPoint(x: 0.0,y: 0.0), radius: 12.0, startAngle: CGFloat(-90 + (125 * percent)), endAngle: CGFloat(270 - (125 * percent)))
            }else{
                newPath.appendArc(withCenter: CGPoint(x: 0.0,y: 0.0), radius: 12.0, startAngle: CGFloat(35 - (125 * percent)), endAngle: CGFloat(145 + (125 * percent)))
            }
            newPath.stroke()
            self.arcNode.path = newPath.cgPath
            self.arcNode.isAntialiased = false
            self.arcNode.strokeColor = self.currentColor // (animated ? self.notAimedAtColor : self.aimedAtColor)
        }))
    }
    
    @discardableResult
    override func drawAndGetCrosshair()->SKSpriteNode{
//        self.inited = true
        self.drawStrokePaths()
        self.createArc()
        return super.drawAndGetCrosshair()
    }
    
    
    func createArc(){
        
        path1.appendArc(withCenter: CGPoint(x: 0.0,y: 0.0), radius: 12.0, startAngle: 35, endAngle: 145)//  360)// 180)
        path1.stroke()
        
        self.arcNode = SKShapeNode(path: path1.cgPath)
        self.arcNode.strokeColor = self.currentColor // .orange
        self.arcNode.isAntialiased = false
        self.nodeContainer.addChild(self.arcNode)
    }
    
    var downStrokeY:CGFloat!
    
    func drawStrokePaths(){
        
        // RIGHT 0
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x + innerDist, y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x + outerDist, y: self.centerPoint.y))))
        
        // LEFT 1
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - innerDist, y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x - outerDist, y: self.centerPoint.y))))

        if(downStrokeY == nil){
           downStrokeY = self.centerPoint.y + innerDist
        }
        // DOWN 2
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - innerDist), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - outerDist))))

        // UP 3
//        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + innerDist), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + outerDist))))
        
        self.nodeContainer.addChild(self.nodeCrosshairShapes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
