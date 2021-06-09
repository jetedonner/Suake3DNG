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

class SniperrifleCrosshairComponent: BaseCrosshairComponent {

    let nodeCrosshairStrokes:SKShapeNode = SKShapeNode()
    var nodeCrosshairOuterCircle:SKShapeNode = SKShapeNode()
    var nodeCrosshairMiddleCircle:SKShapeNode = SKShapeNode()
    var nodeCrosshairCenterCircle:SKShapeNode = SKShapeNode()
    
    var strokeNodes:[SKShapeNode] = [SKShapeNode]()

    var strokeNodesLeft:[SKShapeNode] = [SKShapeNode]()
    var strokeNodesRight:[SKShapeNode] = [SKShapeNode]()
    var strokeNodesUp:[SKShapeNode] = [SKShapeNode]()
    var strokeNodesDown:[SKShapeNode] = [SKShapeNode]()
    
    var strokeNodesCenter:[SKShapeNode] = [SKShapeNode]()
    
    var arcNodes:[SKEffectNode] = [SKEffectNode]()
    var goodyArcNodes:[SKEffectNode] = [SKEffectNode]()
    
    var imgBG:SKSpriteNode!
    let bgImgFile:String = "art.scnassets/overlays/gameplay/images/crosshairSniperEmpty.png"
    
    var isAimedAtPoint:Bool = false
    var innerCrossAimDist:CGFloat = 5.0
    
    override var unavailable:Bool{
        get{ return super.unavailable }
        set{
            super._unavailable = newValue
//            self.nodeCrosshairCenterCircle.strokeColor = self.currentColor
//            self.nodeCrosshairCircle.strokeColor = self.currentColor
//            for strokeNode in self.strokeNodes{
//                strokeNode.strokeColor = self.currentColor
//            }
        }
    }
    
    init(game:GameController) {
        super.init(game: game, weaponType: .sniperrifle)
        
        self.animTime = 0.12
        self.notAimedAtColor = .black
        //self.innerDist = 7.0
        self.outerDist = 345.0
        self.innerDist = self.outerDist / 2
        self.imgBG = SKSpriteNode(texture: SKTexture(imageNamed: self.bgImgFile))
        self.aimedAtPointDistX = 90
    }
    
    func colorStrokeNodes(greenIdx:Int, dist:CGFloat = 0){
        for i in 0..<5{
            strokeNodesLeft[i].strokeColor = (i == greenIdx ? .green : .black)
            strokeNodesRight[i].strokeColor = (i == greenIdx ? .green : .black)
            strokeNodesUp[i].strokeColor = (i == greenIdx ? .green : .black)
            strokeNodesDown[i].strokeColor = (i == greenIdx ? .green : .black)
        }
        
        var showInnerCross:Bool = greenIdx == 0
        if(showInnerCross){
            showInnerCross = (dist <= 0 && dist >= -self.innerCrossAimDist) || (dist >= 0 && dist <= self.innerCrossAimDist)
        }
        self.strokeNodesCenter[0].isHidden = !showInnerCross
        self.strokeNodesCenter[1].isHidden = !showInnerCross
    }
    
    func getDistOfChCenterToPointX(point:SCNVector3)->CGFloat{
        var dist2Point:CGFloat = 0.0
        let tmpPoint = self.game.scnView.projectPoint(point)
        if(tmpPoint.z < 0.5){
            self.colorStrokeNodes(greenIdx: -1, dist: 161)
            return 0.0
        }
        dist2Point = tmpPoint.x - (self.game.gameWindowSize.width / 2)
        if((dist2Point >= -160 && dist2Point <= -130) || (dist2Point <= 160 && dist2Point >= 130)){
            self.colorStrokeNodes(greenIdx: 4, dist: dist2Point)
        }else if((dist2Point >= -130 && dist2Point <= -100) || (dist2Point <= 130 && dist2Point >= 100)){
            self.colorStrokeNodes(greenIdx: 3, dist: dist2Point)
        }else if((dist2Point >= -100 && dist2Point <= -70) || (dist2Point <= 100 && dist2Point >= 70)){
            self.colorStrokeNodes(greenIdx: 2, dist: dist2Point)
        }else if((dist2Point >= -70 && dist2Point <= -40) || (dist2Point <= 70 && dist2Point >= 40)){
            self.colorStrokeNodes(greenIdx: 1, dist: dist2Point)
        }else  if((dist2Point >= -40 && dist2Point <= 0) || (dist2Point <= 40 && dist2Point >= 0)){
            self.colorStrokeNodes(greenIdx: 0, dist: dist2Point)
        }else{
            self.colorStrokeNodes(greenIdx: -1, dist: 161)
        }
        return dist2Point
    }
    
    override func checkAimedAtPoint(point:SCNVector3)->Bool{
        
        _ = self.getDistOfChCenterToPointX(point: point)
        return false
    }
    
    override func animateCrosshair(animated:Bool){
        self.animationOut = animated
    }
    
    func createOuterCircle(){
        self.nodeCrosshairOuterCircle = SKShapeNode(circleOfRadius: self.outerDist / 6)
        self.nodeCrosshairOuterCircle.position = CGPoint(x: 0, y: 0)
        self.nodeCrosshairOuterCircle.strokeColor = self.notAimedAtColor
        self.nodeCrosshairOuterCircle.lineWidth = 1.0
        self.nodeCrosshairOuterCircle.isAntialiased = false
        self.nodeCrosshairOuterCircle.yScale = 6.0
        self.nodeCrosshairOuterCircle.xScale = 6.0
        self.nodeContainer.addChild(self.nodeCrosshairOuterCircle)
    }
    
    func createMiddleCircle(){
        self.nodeCrosshairMiddleCircle = SKShapeNode(circleOfRadius: self.innerDist / 6)
        self.nodeCrosshairMiddleCircle.position = CGPoint(x: 0, y: 0)
        self.nodeCrosshairMiddleCircle.strokeColor = self.notAimedAtColor
        self.nodeCrosshairMiddleCircle.lineWidth = 0.2
        self.nodeCrosshairMiddleCircle.isAntialiased = false
        self.nodeCrosshairMiddleCircle.yScale = 6.0
        self.nodeCrosshairMiddleCircle.xScale = 6.0
        self.nodeContainer.addChild(self.nodeCrosshairMiddleCircle)
    }
    
    @discardableResult
    override func drawAndGetCrosshair()->SKSpriteNode{
        self.imgBG.zPosition = 999
        self.node.addChild(self.imgBG)
        self.drawStrokePaths()
        self.createOuterCircle()
        self.createMiddleCircle()
//        self.createCenterCircle()
        self.drawLabels()
        self.addArcs()
        self.updateGoodyArc()
        
        return super.drawAndGetCrosshair()
    }
    
    func addArcs(){
        self.arcNodes.append(self.addArcPart(startAngle: 50, endAngle: 130))
        self.goodyArcNodes.append(self.addArcPart2(startAngle: 53, endAngle: 127))
        self.updateGoodyArc()
    }
    
    func updateGoodyArc(){
        let ownPos:SCNVector3 = self.game.playerEntityManager.ownPlayerEntity.pos
        let goodyPos:SCNVector3 = self.game.playerEntityManager.goodyEntity.pos
        let X:CGFloat = goodyPos.x - ownPos.x
        let Z:CGFloat = goodyPos.z - ownPos.z
        var baseAng:CGFloat = -360.0
        var ang:CGFloat = 0.0
        
        if(Z < 0){
            baseAng = -180.0
        }else{
            if(X < 0){
                baseAng = 0.0
            }
        }
        
        if(Z == 0){
            if(X < 0){
                ang = -90.0
            }else{
                ang = -270.0
            }
        }else{
            var arctangent = atan(goodyPos.x / goodyPos.z) * 180.0
            arctangent = arctangent / CGFloat.pi
            let angDif = baseAng + arctangent
            ang = angDif
        }
        
        if(ang >= -315.0 && ang <= -225.0){
            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .W)
        }else if(ang >= -225.0 && ang <= -135.0){
            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .S)
        }else if(ang >= -135.0 && ang <= -45.0){
            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .E)
        }else{
            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .N)
        }
        return
    }
    
    func showArcNode4Degree(degree:CGFloat = 0){
        let newDegree = degree
        var sniperDirection:SniperVisionDirectionFull = .N
        if(newDegree >= 45 && newDegree <= 135){
            sniperDirection = .E
        }else if(newDegree >= 135 && newDegree <= 225){
            sniperDirection = .S
        }else if(newDegree >= 225 && newDegree <= 315){
            sniperDirection = .W
        }else if(newDegree >= 315 && newDegree <= 45){
            sniperDirection = .N
        }
        self.rotateArcTo(shapeNode: self.arcPart, direction: sniperDirection)
    }
    
    func rotateArcTo(shapeNode:SKShapeNode, direction:SniperVisionDirectionFull){
            self.game.showDbgMsg(dbgMsg: "rotateGoodyArc(direction: " + direction.toString() + ")", dbgLevel: .Verbose)
    
            var toAngle:CGFloat = 0.0
    
            switch direction {
            case .N:
                toAngle = 0.0
                break
            case .E:
                toAngle = CGFloat.pi * 1.5
                break
            case .S:
                toAngle = CGFloat.pi * 1.0
                break
            case .W:
                toAngle = CGFloat.pi * 0.5
                break
            }
            shapeNode.run(SKAction.rotate(toAngle: toAngle, duration: self.animTime, shortestUnitArc: true))
        }

    func showArcNode(sniperDirection:SniperVisionDirectionFull){
        if(self.arcNodes.count >= 4){
//            self.arcNodes[SniperVisionDirectionFull.N.rawValue].isHidden = (sniperDirection != SniperVisionDirectionFull.N)
//            self.arcNodes[SniperVisionDirectionFull.E.rawValue].isHidden = (sniperDirection != SniperVisionDirectionFull.E)
//            self.arcNodes[SniperVisionDirectionFull.S.rawValue].isHidden = (sniperDirection != SniperVisionDirectionFull.S)
//            self.arcNodes[SniperVisionDirectionFull.W.rawValue].isHidden = (sniperDirection != SniperVisionDirectionFull.W)
        }
    }
    
    var lblAngel:SKLabelNode = SKLabelNode(fontNamed: SuakeVars.defaultFontName)
    var lblZoom:SKLabelNode = SKLabelNode(fontNamed: SuakeVars.defaultFontName)
    
    let lblDist:CGFloat = 7.0
    let minZoom:CGFloat = 1.0
    let maxZoom:CGFloat = 9.9999999
    var zoomFactor:CGFloat = 1.0
    
    func addArcPart(startAngle:CGFloat, endAngle:CGFloat)->SKEffectNode{
        
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view!.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view!.addSubview(blurEffectView)
        
        let path:NSBezierPath = NSBezierPath()
        path.appendArc(withCenter: CGPoint(x: 0.0,y: 0.0), radius: 260.0, startAngle: startAngle, endAngle: endAngle)
        path.stroke()
        
        let newShapeNode:SKShapeNode =  SKShapeNode(path: path.cgPath)
        newShapeNode.strokeColor = NSColor(ciColor: .white).withAlphaComponent(0.45)
        newShapeNode.lineWidth = 132.0
        newShapeNode.isAntialiased = false
        
//        let blurEffect:NSVisualEffectView = NSVisualEffectView(frame: newShapeNode.frame)
//        blurEffect.blendingMode = .
        let effectNode:SKEffectNode = SKEffectNode()
        let filter:CIFilter = CIFilter(name:"CIGaussianBlur")!
        filter.setValue(15, forKey: "inputRadius")
        effectNode.filter = filter
//        effectNode.blendMode = .subtract
        effectNode.addChild(newShapeNode)
        arcPart.addChild(effectNode)
        self.nodeContainer.addChild(self.arcPart)
        return effectNode
    }
    
    let arcPartGoody:SKShapeNode = SKShapeNode()
    let arcPart:SKShapeNode = SKShapeNode()
    
    func addArcPart2(startAngle:CGFloat, endAngle:CGFloat)->SKEffectNode{
        let path:NSBezierPath = NSBezierPath()
        path.appendArc(withCenter: CGPoint(x: 0.0,y: 0.0), radius: 300.0, startAngle: startAngle, endAngle: endAngle)
        path.stroke()
        
        let newShapeNode:SKShapeNode =  SKShapeNode(path: path.cgPath)
        newShapeNode.strokeColor = NSColor.orange.withAlphaComponent(0.65)
        newShapeNode.lineWidth = 32.0
        newShapeNode.isAntialiased = false
        
        let effectNode:SKEffectNode = SKEffectNode()
        let filter:CIFilter = CIFilter(name:"CIGaussianBlur")!
        filter.setValue(5, forKey: "inputRadius")
        effectNode.filter = filter
        
        effectNode.addChild(newShapeNode)
        arcPartGoody.addChild(effectNode)
        self.nodeContainer.addChild(arcPartGoody)
        return effectNode
    }
    
    func drawLabels(){
        self.setZoomLbl(zoomFactor: self.minZoom)
        self.lblZoom.position.x += self.outerDist - (self.lblZoom.frame.width / 2) - self.lblDist
        self.lblZoom.position.y += self.lblDist
        self.nodeContainer.addChild(self.lblZoom)

        self.setAngelLbl(angel: 0.0)
        self.lblAngel.position.x -= self.outerDist - (self.lblZoom.frame.width / 2) - (self.lblDist * 2)
        self.lblAngel.position.y -=  self.lblAngel.frame.height + self.lblDist
        self.nodeContainer.addChild(self.lblAngel)
    }
    
    func setAngelLbl(angel:CGFloat){
        self.showArcNode4Degree(degree: angel)
        //self.lblAngel.attributedText = String(angel.truncate(places: 0).description + " °").asStylizedDegrees()
        self.lblAngel.text = angel.truncate(places: 0).description + "°"
    }
    
    func setZoomLbl(zoomFactor:CGFloat){
        self.lblZoom.text = "x" + zoomFactor.truncate(places: 1).description
    }
    
    public func magnify(magnification:CGFloat)->Bool{
        let zoomMag:CGFloat = magnification * 10
        if((self.zoomFactor + zoomMag) >= self.minZoom && (zoomFactor + zoomMag) <= self.maxZoom){
            zoom(zoom: zoomMag)
            return true
        }
        return false
    }
    
    public func zoom(zoom:CGFloat){
        if(self.zoomFactor == 1.0){
            //initialFPCamPos = game.cameraHelper.cameraNodeFP.position
        }
        self.zoomFactor += zoom
        self.setZoomLbl(zoomFactor: zoomFactor)
        //updateZoomCamPos()
    }
    
    let smallStrokesLength:CGFloat = 10.0
    let halfSmallStrokesLength:CGFloat = 5.0
    func drawStrokePaths(){
        let distInner:CGFloat = self.innerDist / 6
        
        // RIGHT 0
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - (outerDist / 2), y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x + (outerDist / 2), y: self.centerPoint.y)), color: .black))
        
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + (outerDist / 2)), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - (outerDist / 2))), color: .black))
        
        for i in (1..<6){
            let len:CGFloat = (i % 3 == 0 ? self.smallStrokesLength: self.halfSmallStrokesLength)
            self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - len, y: self.centerPoint.y + (distInner * CGFloat(i))), to: CGPoint(x: self.centerPoint.x + len, y: self.centerPoint.y + (distInner * CGFloat(i)))), color: .black))
            
            self.strokeNodesUp.append(self.strokeNodes.last!)
            
            self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - len, y: self.centerPoint.y - (distInner * CGFloat(i))), to: CGPoint(x: self.centerPoint.x + len, y: self.centerPoint.y - (distInner * CGFloat(i)))), color: .black))
            
            self.strokeNodesDown.append(self.strokeNodes.last!)
            
            self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x + (distInner * CGFloat(i)), y: self.centerPoint.y + len), to: CGPoint(x: self.centerPoint.x + (distInner * CGFloat(i)), y: self.centerPoint.y - len)), color: .black))

            self.strokeNodesRight.append(self.strokeNodes.last!)
            
            self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - (distInner * CGFloat(i)), y: self.centerPoint.y + len), to: CGPoint(x: self.centerPoint.x - (distInner * CGFloat(i)), y: self.centerPoint.y - len)), color: .black))
            
            self.strokeNodesLeft.append(self.strokeNodes.last!)
            
            self.strokeNodesCenter.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - 10, y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x + 10, y: self.centerPoint.y)), lineWidth: 2.0, color: .black))
            
            self.strokeNodesCenter.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + 10), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - 10)), lineWidth: 2.0, color: .black))
            
            self.strokeNodesCenter[0].strokeColor = .green
            self.strokeNodesCenter[0].zPosition = 10000
            self.strokeNodesCenter[0].isHidden = true
            self.strokeNodesCenter[1].strokeColor = .green
            self.strokeNodesCenter[1].zPosition = 10000
            self.strokeNodesCenter[1].isHidden = true
        }
        
        var idx:Int = 0
        for stroke in self.strokeNodes{
            stroke.lineWidth = 1.0
//            if(idx > 1){
//                //stroke.strokeColor = .darkGray
//            }
            idx += 1
        }
        self.addOuterShape(angle: 45)
        self.addOuterShape(angle: 135)
        self.addOuterShape(angle: 225)
        self.addOuterShape(angle: 315)
        
        self.nodeContainer.addChild(self.nodeCrosshairShapes)
    }
    
    func addOuterShape(angle:CGFloat){
        let start:CGPoint = CGPoint(x: sin(angle/180*CGFloat.pi) * (outerDist / 2), y: cos(angle/180*CGFloat.pi) * (outerDist / 2))
        let end:CGPoint = CGPoint(x: sin(angle/180*CGFloat.pi) * (outerDist), y: cos(angle/180*CGFloat.pi) * (outerDist))
        let new:NSBezierPath = NSBezierPath()
        new.move(to: start)
        new.line(to: end)
        let newShape:SKShapeNode = SKShapeNode()
        newShape.path = new.cgPath
        newShape.strokeColor = .black
        self.nodeCrosshairShapes.addChild(newShape)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
