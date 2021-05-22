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

class RedeemerCrosshairComponent: BaseCrosshairComponent {

    let redeemerCrosshairView:RedeemerCrosshairView
    let nodeCrosshairStrokes:SKShapeNode = SKShapeNode()
    let nodeCrosshairPies:SKShapeNode = SKShapeNode()
    var nodeCrosshairCircle:SKShapeNode = SKShapeNode()
    var nodeCrosshairCircleMiddle:SKShapeNode = SKShapeNode()
    
    var strokeNodes:[SKShapeNode] = [SKShapeNode]()
    var pieNodes:[SKShapeNode] = [SKShapeNode]()
    
    let lastPieAnimateDelay:TimeInterval = 0.15
    let pieAnimateDistance:CGFloat = 5.0
    
//    override var unavailable:Bool{
//        get{ return super.unavailable }
//        set{
//            super.unavailable = newValue
//            self.arcNode.strokeColor = self.currentColor
//            for strokeNode in self.strokeNodes{
//                strokeNode.strokeColor = self.currentColor
//            }
//        }
//    }
    
    override var isHidden:Bool{
        get{ return self.node.isHidden }
        set{
            self.node.isHidden = (self.game.cameraHelper.fpv ? newValue : true)
            self.redeemerCrosshairView.hide(hide: (self.game.cameraHelper.fpv ? newValue : true))
        }
    }
    
    init(game:GameController) {
        self.redeemerCrosshairView = RedeemerCrosshairView(game: game)
        super.init(game: game, weaponType: .redeemer)
        self.animTime = 0.05
    }
    
    func showRocketView(show:Bool = true, nuke:Nuke? = nil){
        
        //game.scnView.pointOfView = self.cameraNode
        if(!show){
            self.game.scnView.pointOfView = self.game.cameraHelper.cameraNodeFP
            self.game.overlayManager.showOverlay4GameState(type: .playing)
        }else{
            if(nuke != nil){
                self.game.scnView.pointOfView = nuke?.cameraNode
            }
            self.game.overlayManager.showOverlay4GameState(type: .nukeView)
            self.game.overlayManager.nukeView.startOverlay()
        }
    }
    
    override func animateCrosshair(animated:Bool){
        self.animationOut = animated
        if(animated){
            self.nodeCrosshairCircle.isHidden = animated
        }
        self.redeemerCrosshairView.animate(animated: animated, completed: {
            if(!animated){
                self.nodeCrosshairCircle.isHidden = animated
            }
        })
        self.game.showDbgMsg(dbgMsg: "Animate REDEEMER CROSSHAIR to: " + animated.description, dbgLevel: .Info)
        
//        if(DbgVars.playAimingSounds){
//            if(!animated){
//                self.game.audioManager.playSound(soundType: .redeemerAimed)
//            }else{
//                self.game.audioManager.playSound(soundType: .redeemerUnaimed)
//            }
//        }
    }
    
    override func drawAndGetCrosshair()->SKSpriteNode{
//        //self.drawStrokePaths()
//        self.drawPiePaths()
//        self.createCenterCircle()
//        self.createMiddleCircle()
////        self.createMorphable()
        //self.drawCenterRect()
        self.createCenterCircle()
        return super.drawAndGetCrosshair()
    }
    
//    var nodeCrosshairCenterCircle:SKShapeNode = SKShapeNode()
//    func createCenterCircle(){
//        self.nodeCrosshairCenterCircle = SKShapeNode(circleOfRadius: 1.0)
//        self.nodeCrosshairCenterCircle.position = CGPoint(x: 0, y: 0)
//        self.nodeCrosshairCenterCircle.strokeColor = self.startColor
//        self.nodeCrosshairCenterCircle.lineWidth = 1.0
//        self.nodeCrosshairCenterCircle.isAntialiased = false
//        self.nodeContainer.addChild(self.nodeCrosshairCenterCircle)
//    }
    
    
    var rectShape:SKShapeNode = SKShapeNode()
    func drawCenterRect(){
        let path = CGMutablePath();
        path.move(to: CGPoint(x: 50,y: 10))
        path.addLine(to: CGPoint(x: 90, y: 10))
        path.addLine(to: CGPoint(x: 90, y: 50))
        path.addLine(to: CGPoint(x: 50, y: 50))
        path.addLine(to: CGPoint(x: 50, y: 10))

        //: Add a CAShapeLayer to it, configure its line & fill colors
        let shape = CAShapeLayer()
        shape.frame = self.game.overlayManager.hud.overlayScene.view!.bounds.insetBy(dx: 10, dy: 10)
        shape.bounds = self.game.overlayManager.hud.overlayScene.view!.bounds
        shape.fillColor = NSColor.orange.withAlphaComponent(0.3).cgColor
        shape.strokeColor = NSColor.orange.cgColor
        shape.lineWidth = 3
        shape.path = path
        self.game.overlayManager.hud.overlayScene.view!.layer!.addSublayer(shape)
        self.game.overlayManager.hud.overlayScene.view!.layer!.layoutSublayers()
        self.game.overlayManager.hud.overlayScene.forceRedraw()
        
        self.rectShape = SKShapeNode(path: path, centered: true)
        self.rectShape.position = CGPoint(x: 0,y: 0);
        self.rectShape.zRotation = CGFloat.pi * 0.25
        self.rectShape.strokeColor = self.notAimedAtColor
        self.nodeContainer.addChild(self.rectShape)
    }
    
    func animateArcs(animated:Bool){
        if(animated){
            for i in 0..<self.arcNodesMiddle.count{
                self.arcNodesMiddle[i].removeAllActions()
                self.arcNodesMiddle[i].alpha = 0
                self.nodeCrosshairCircle.isHidden = animated || self.animationOut
            }
        }else{
            for i in 0..<self.arcNodesMiddle.count{
                self.arcNodesMiddle[i].alpha = 0
                self.arcNodesMiddle[i].strokeColor = .orange
                self.arcNodesMiddle[i].xScale = 1.0
                self.arcNodesMiddle[i].yScale = 1.0
                self.arcNodesMiddle[i].run(SKAction.sequence([SKAction.wait(forDuration: Double(i) * 0.012), SKAction.group([ SKAction.fadeIn(withDuration: 0.25), SKAction.scale(to: 0.5, duration: 0.15)])]), completion: {
                    self.arcNodesMiddle[i].strokeColor = .green
                    
                    if(i == self.arcNodesMiddle.count - 1){
                        self.nodeCrosshairCircle.isHidden = animated || self.animationOut
                        self.nodeCrosshairCircle.strokeColor = (animated || self.animationOut ? self.notAimedAtColor : self.aimedAtColor)
                    }
                })
            }
        }
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
    
    let animMultiply:Double = 0.667
    let pieMaxScale:CGFloat = 1.0
    let pieMinScale:CGFloat = 0.65
    
    func animatePies(animated:Bool){
        var idx:Int = 0
        let mult:CGFloat = (animated ? 1.0 : -1.0)
        for pie in self.pieNodes{
            if(idx == 0){
                pie.run(
                    SKAction.group([
                        SKAction.moveBy(x: mult * self.pieAnimateDistance, y: mult * self.pieAnimateDistance, duration: self.animTime),
                        SKAction.scale(to: (animated ? self.pieMaxScale : self.pieMinScale), duration: self.animTime)
                    ])
                )
            }else if(idx == 1){
                pie.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: (animated ? self.animTime : self.animTime) * animMultiply),
                        SKAction.group([
                            SKAction.moveBy(x: mult * -self.pieAnimateDistance, y: mult * self.pieAnimateDistance, duration: self.animTime),
                            SKAction.scale(to: (animated ? self.pieMaxScale : self.pieMinScale), duration: self.animTime)
                        ])
                    ])
                )
            }else if(idx == 2){
                pie.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: (animated ? self.animTime * animMultiply * 2 : self.animTime * animMultiply * 2)),
                        SKAction.group([
                            SKAction.moveBy(x: mult * -self.pieAnimateDistance, y: mult * -self.pieAnimateDistance, duration: self.animTime),
                            SKAction.scale(to: (animated ? self.pieMaxScale : self.pieMinScale), duration: self.animTime)
                        ])
                    ])
                )
            }else if(idx == 3){
                pie.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: (animated ? self.animTime * animMultiply * 3 : self.animTime * animMultiply * 3)),
                        SKAction.group([
                            SKAction.moveBy(x: mult * self.pieAnimateDistance, y: mult * -self.pieAnimateDistance, duration: self.animTime),
                            SKAction.scale(to: (animated ? self.pieMaxScale : self.pieMinScale), duration: self.animTime)
                        ])
                    ]),
                    completion: {
                        for stroke in self.strokeNodes{
                            stroke.strokeColor = (animated || self.animationOut ? self.notAimedAtColor : self.aimedAtColor)
                        }
                    
                        for pie in self.pieNodes{
                            pie.strokeColor = (animated || self.animationOut ? self.notAimedAtColor : self.aimedAtColor)
                            //pie.fillColor = (animated || self.animationOut ? self.startColor : self.endColor)
                        }
//                        self.nodeCrosshairCircle.isHidden = animated || self.animationOut
//                        self.nodeCrosshairCircle.strokeColor = (animated || self.animationOut ? self.startColor : self.endColor)
                        self.game.showDbgMsg(dbgMsg: ".animatePies(" + animated.description + "), .animationOut = " + self.animationOut.description, dbgLevel: .Verbose)
                    }
                )
            }
            idx += 1
        }
    }
    
    func createCenterCircle(){
        self.nodeCrosshairCircle = SKShapeNode(circleOfRadius: 1.0)
        self.nodeCrosshairCircle.position = CGPoint(x: 0, y: 0)
        self.nodeCrosshairCircle.strokeColor = self.aimedAtColor
        self.nodeCrosshairCircle.lineWidth = 1.0
        self.nodeCrosshairCircle.isAntialiased = false
        self.nodeCrosshairCircle.isHidden = true
        self.nodeContainer.addChild(self.nodeCrosshairCircle)
    }
    
    var arcNodesMiddle:[SKShapeNode] = [SKShapeNode]()
    var arcNodesMiddleContainer:SKShapeNode = SKShapeNode()
    func appendArcShape(path:CGPath){
        let arcNode:SKShapeNode = SKShapeNode(path: path)
        arcNode.strokeColor = .orange
        arcNode.isAntialiased = false
        arcNode.lineWidth = 2.0
        arcNode.alpha = 0
        self.arcNodesMiddle.append(arcNode)
        self.arcNodesMiddleContainer.addChild(arcNode)
    }
    
    func createMiddleCircle(){
    
        let fullSize:Int = 360
        let partSize:Int = 8
        let partCount:Int = fullSize / partSize
        let pairCount:Int = partCount / 2
        
        for i in 0..<pairCount{
            let newPath:NSBezierPath = NSBezierPath()
            newPath.appendArc(withCenter: CGPoint(x: 0.0,y: 0.0), radius: 35.0, startAngle: CGFloat((i * partSize * 2)), endAngle: CGFloat((i * partSize * 2) + partSize))
            newPath.close()
            newPath.stroke()
            self.appendArcShape(path: newPath.cgPath)
        }
        self.nodeContainer.addChild(self.arcNodesMiddleContainer)
    }
    
    let newPathMorph1:NSBezierPath = NSBezierPath()
    let newPathMorph2:NSBezierPath = NSBezierPath()
    var morphableShape:SKShapeNode!
    let shapeLayer = CAShapeLayer()
    
    func createMorphable(){
        
        
        self.shapeLayer.fillColor = .clear
        self.shapeLayer.strokeColor = self.notAimedAtColor.cgColor
        self.shapeLayer.path = self.newPathMorph1.cgPath
//        self.game.overlayManager.hud.view?.layer!.addSublayer(self.shapeLayer)
        //self.game.overlayManager.hud.view?.layer!.layoutSublayers()
        
        self.newPathMorph1.appendRect(NSRect(x: 50, y: 50, width: 20, height: 20))
        self.newPathMorph1.close()
        self.newPathMorph1.stroke()
        
        self.newPathMorph2.appendRect(NSRect(x: 50, y: 50, width: 40, height: 40))
        self.newPathMorph2.close()
        self.newPathMorph2.stroke()
        
        self.morphableShape = SKShapeNode(path: self.newPathMorph1.cgPath)
        self.morphableShape.strokeColor = .orange
        self.morphableShape.isAntialiased = false
        self.morphableShape.lineWidth = 2.0
//        self.nodeContainer.addChild(self.morphableShape)
    }
    
    func addSublayer(hud:HUDOverlayScene){
        hud.view?.layer!.addSublayer(self.shapeLayer)
    }
    
    func animateMorphable(){
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 1.0
        animation.fromValue = newPathMorph1.cgPath
        animation.toValue = self.newPathMorph2.cgPath
        animation.fillMode = .both
        animation.repeatCount = .greatestFiniteMagnitude
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false

        self.morphableShape.isPaused = false
        self.shapeLayer.add(animation, forKey: "path")
        
        self.morphableShape.run(SKAction.customAction(withDuration: animation.duration, actionBlock: {(node, timeDuration) in
            print("timeDuration: " + timeDuration.description)
//            animation.set
            (node as! SKShapeNode).path =
                self.shapeLayer.presentation()?.path
        }))
    }
    
    func animateMorphableBack(){
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 1.0
//        animation.fromValue = newPathMorph1.cgPath
        animation.toValue = self.newPathMorph1.cgPath
        animation.fillMode = .forwards
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        animation.fillMode = CAMediaTimingFillMode.both
//        animation.repeatCount = .greatestFiniteMagnitude // Infinite repeat
//        animation.autoreverses = true
        animation.isRemovedOnCompletion = false

        //self.shapeLayer.add(animation, forKey: "path") //animation.keyPath)
        self.shapeLayer.removeAllAnimations()
        self.shapeLayer.add(animation, forKey: "prepanimation")
        morphableShape.run(SKAction.customAction(withDuration: animation.duration, actionBlock: {(node, timeDuration) in
            print("timeDuration Back: " + timeDuration.description)
//            animation.set
            (node as! SKShapeNode).path =
                self.shapeLayer.presentation()?.path
        }))
        //self.morphableShape.add(animation, forKey: animation.keyPath)
    }
    
    
    let pieRadius:CGFloat = 10.0
    let pieDistance:CGFloat = 15.0
    
    func createPieShape(x:CGFloat, y:CGFloat, startAngle:CGFloat, endAngle:CGFloat)->SKShapeNode{
        let shapeNode:SKShapeNode = SKShapeNode()
        shapeNode.fillColor = .clear // self.startColor
        shapeNode.strokeColor = self.notAimedAtColor
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addArc(center: CGPoint.zero, radius: self.pieRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
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
        
//        self.pieNodes[0].strokeColor = .white
        self.pieNodes[0].fillColor = .clear
        
        self.pieNodes[1].fillColor = .clear
        self.pieNodes[2].fillColor = .clear
        self.pieNodes[3].fillColor = .clear
        
        self.nodeCrosshairPies.zRotation = CGFloat(Float.pi) / 4// CGFloat(Float.pi) / -6
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
