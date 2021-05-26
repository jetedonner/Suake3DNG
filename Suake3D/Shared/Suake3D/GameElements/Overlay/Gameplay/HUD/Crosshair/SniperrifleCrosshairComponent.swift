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
    
    init(game:GameController) {
        super.init(game: game, weaponType: .sniperrifle)
        
        self.animTime = 0.12
        
        self.notAimedAtColor = .black
        //self.innerDist = 7.0
        self.outerDist = 345.0
        self.innerDist = self.outerDist / 2
        self.imgBG = SKSpriteNode(texture: SKTexture(imageNamed: self.bgImgFile))
//        self.setZoomLbl(zoomFactor: 1.0)
        self.aimedAtPointDistX = 90
    }
    
    var isAimedAtPoint:Bool = false
    var innerCrossAimDist:CGFloat = 5.0
    
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
//        self.nodeCrosshairCenterCircle.isHidden = !showInnerCross
    }
    
    func getDistOfChCenterToPointX(point:SCNVector3)->CGFloat{
        var dist2Point:CGFloat = 0.0
        let tmpPoint = self.game.scnView.projectPoint(point)
        if(tmpPoint.z < 0.5){
            self.colorStrokeNodes(greenIdx: -1, dist: 161)
            return 0.0
        }
        dist2Point = tmpPoint.x - (self.game.gameWindowSize.width / 2)
//        print("dist2Point: " + dist2Point.description)
        
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
        
//        let tmpPoint = self.game.scnView.projectPoint(point)
//        if(tmpPoint.x >= (self.game.gameWindowSize.width / 2) - 17 && tmpPoint.x <= (self.game.gameWindowSize.width / 2) + 17 && tmpPoint.y >= (self.game.gameWindowSize.height / 2) - 40 && tmpPoint.y <= (self.game.gameWindowSize.height / 2) + 40 && tmpPoint.z < 1.0){
//            if(!self.isAimedAtPoint){
//                self.isAimedAtPoint = true
//                print("Sniperrifle aimed at point ...")
//            }
//            //return true
//        }else{
//            if(self.isAimedAtPoint){
//                self.isAimedAtPoint = false
//                //print("Sniperrifle NOT aimed at point ...")
//            }
//            //return false
//        }
        return false
    }
    
    override func animateCrosshair(animated:Bool){
        self.animationOut = animated
//        self.animateStrokes(animated: animated)
//        self.animateArc(animated: animated)
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
    
    func createCenterCircle(){
        self.nodeCrosshairCenterCircle = SKShapeNode(circleOfRadius: 17.0)
        self.nodeCrosshairCenterCircle.position = CGPoint(x: 0, y: 0)
        self.nodeCrosshairCenterCircle.strokeColor = .green
        self.nodeCrosshairCenterCircle.lineWidth = 1.0
        self.nodeCrosshairCenterCircle.isAntialiased = false
        self.nodeCrosshairCenterCircle.zPosition = 10000
        self.nodeCrosshairCenterCircle.isHidden = true
        self.nodeContainer.addChild(self.nodeCrosshairCenterCircle)
    }
    
//    var inited:Bool = false
    
//    func drawAndGetCrosshairNG()->SKSpriteNode{
    @discardableResult
    override func drawAndGetCrosshair()->SKSpriteNode{
//        inited = true
        self.imgBG.zPosition = 999
        self.node.addChild(self.imgBG)
        self.drawStrokePaths()
        self.createOuterCircle()
        self.createMiddleCircle()
        self.createCenterCircle()
        self.drawLabels()
        self.addArcs()
        //self.updateGoodyArc()
        //self.nodeContainer.addChild(self.difuseSpriteNOde)
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
//        NORTH / WEST => (-360° + X)
//        1.  X: 10, Z: 10 => 10/10 => arctan(1) = 45° => -360° + 45° => -315° => North-West (exact)
//        2.  X: 10, Z: 5 => 10/5 => arctan(2) = 63.43° => -360° + 63.43° => -296.56° => West
//        3.  X: 5, Z: 10 => 5/10 => arctan(0.5) = 26.56° => -360° + 26.56° => -333.43° => North
//        4.  X: 0, Z: 10 => 0/10 => arctan(0) = 0° => -360° + 0° => -360° => North (exact)
//
//        SOUTH / WEST (-180° + X)
//        5.  X: 10, Z: -10 => 10/-10 => arctan(-1) = -45° => -180° + -45° => -225° => South-West (exact)
//        6.  X: 10, Z: -5 => 10/-5 => arctan(-2) = -63.43° => -180° + -63.43° => -243.43° => West
//        7.  X: 5, Z: -10 => 5/-10 => arctan(-0.5) = -26.56° => -180° + -26.56° => -206.56° => South
//        8.  X: 0, Z: -10 => 0/-10 => arctan(0) = 0° => -180° + 0° => -180° => South (exact)
//
//        SOUTH / EAST
//        9.  X: -10, Z: -10 => -10/-10 => arctan(1) = 45° => -180° + 45° => -135° => South-East (exact)
//        10. X: -10, Z: -5 => -10/-5 => arctan(2) = 63.43° => -180° + 63.43° => -116.57° => East
//        11. X: -5, Z: -10 => -5/-10 => arctan(0.5) = 26.56° => -180° + 26.56° => -153.44° => South
//        !!!!!! 12. X: -10, Z: 0 => -10/0 => arctan(1) = 90° => -180° + 90° => -90° => East (exact) !!!!! => Z == 0 && X < 0 => -90°
//        !!!!!! 13. X: 10, Z: 0 => 10/0 => arctan(1) = 270° => -180° + -90° => -270° => West (exact) !!!!! => Z == 0 && X > 0 => -270°
//
//        NORTH / EAST
//        14. X: -10, Z: 10 => -10/10 => arctan(-1) = -45° => 0° + -45° => -45° => North-East (exact)
//        15. X: -10, Z: 5 => -10/5 => arctan(-2) = -63.43° => 0° + -63.43° => -63.43° => East
//        16. X: -5, Z: 10 => -5/10 => arctan(-0.5) = -26.56° => 0° + -26.56° => -26.56° => North
        var baseAng:CGFloat = -360.0
        if(Z < 0){
            baseAng = -180.0
        }else{
            if(X < 0){
                baseAng = 0.0
            }
        }
        var ang:CGFloat = 0.0
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
    //        if(goodyPos.z < 0){
    //            angDif = 180 - arctangent
    //        }
//            angDif = angDif.truncatingRemainder(dividingBy: 360.0) //360.0
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
//        // OLD VERSION
//        var arctangent = atan(goodyPos.x / goodyPos.z) * 180.0
//        arctangent = arctangent / CGFloat.pi
//        var angDif = 360 - arctangent
////        if(goodyPos.z < 0){
////            angDif = 180 - arctangent
////        }
//        angDif = angDif.truncatingRemainder(dividingBy: 360.0) //360.0
//        if(angDif <= 315.0 && angDif >= 225.0){
//            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .W)
//        }else if(angDif <= 225.0 && angDif >= 135.0){
//            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .N)
//        }else if(angDif <= 135.0 && angDif >= 45.0){
//            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .E)
//        }else{
//            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .S)
//        }
//        return
////        let ntmp =
//        if((goodyPos.z >= 0) && (goodyPos.x >= 0 && goodyPos.x <= goodyPos.z) || (goodyPos.x < 0 && goodyPos.x >= -goodyPos.z)) {
//            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .N)
//        }else if((goodyPos.z < 0) && (goodyPos.x >= 0 && goodyPos.x <= -goodyPos.z) || (goodyPos.x < 0 && goodyPos.x >= goodyPos.z)) {
//            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .S)
//        }else if((goodyPos.x >= 0) && (goodyPos.z >= 0 && goodyPos.z <= goodyPos.x) || (goodyPos.z < 0 && goodyPos.z >= -goodyPos.x)) {
//            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .W)
//        }else if((goodyPos.x < 0) && (goodyPos.z >= 0 && goodyPos.z <= -goodyPos.x) || (goodyPos.z < 0 && goodyPos.z >= goodyPos.x)) {
//            self.rotateArcTo(shapeNode: self.arcPartGoody, direction: .E)
//        }
    }
    
    func showArcNode4Degree(degree:CGFloat = 0){
        let newDegree = degree
//        if(newDegree < 0.0){
//            newDegree += 360.0
//        }
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
    
//    func showArcNode(sniperDirection:SniperVisionDirection){
//        if(self.arcNodes.count >= 4){
//            self.arcNodes[SniperVisionDirection.NE.rawValue].isHidden = (sniperDirection != SniperVisionDirection.NE)
//            self.arcNodes[SniperVisionDirection.NW.rawValue].isHidden = (sniperDirection != SniperVisionDirection.NW)
//            self.arcNodes[SniperVisionDirection.SW.rawValue].isHidden = (sniperDirection != SniperVisionDirection.SW)
//            self.arcNodes[SniperVisionDirection.SE.rawValue].isHidden = (sniperDirection != SniperVisionDirection.SE)
//        }
//    }
    
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
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - (outerDist / 2), y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x + (outerDist / 2), y: self.centerPoint.y))))
        
        self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + (outerDist / 2)), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - (outerDist / 2)))))
        
        for i in (1..<6){
            let len:CGFloat = (i % 3 == 0 ? self.smallStrokesLength: self.halfSmallStrokesLength)
            self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - len, y: self.centerPoint.y + (distInner * CGFloat(i))), to: CGPoint(x: self.centerPoint.x + len, y: self.centerPoint.y + (distInner * CGFloat(i))))))
            
            self.strokeNodesUp.append(self.strokeNodes.last!)
            
            self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - len, y: self.centerPoint.y - (distInner * CGFloat(i))), to: CGPoint(x: self.centerPoint.x + len, y: self.centerPoint.y - (distInner * CGFloat(i))))))
            
            self.strokeNodesDown.append(self.strokeNodes.last!)
            
            self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x + (distInner * CGFloat(i)), y: self.centerPoint.y + len), to: CGPoint(x: self.centerPoint.x + (distInner * CGFloat(i)), y: self.centerPoint.y - len))))

            self.strokeNodesRight.append(self.strokeNodes.last!)
            
            self.strokeNodes.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - (distInner * CGFloat(i)), y: self.centerPoint.y + len), to: CGPoint(x: self.centerPoint.x - (distInner * CGFloat(i)), y: self.centerPoint.y - len))))
            
            self.strokeNodesLeft.append(self.strokeNodes.last!)
            
            self.strokeNodesCenter.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x - 10, y: self.centerPoint.y), to: CGPoint(x: self.centerPoint.x + 10, y: self.centerPoint.y)), lineWidth: 3.0))
            
            self.strokeNodesCenter.append(self.createShapeFromPath(path: self.drawStrokePath(from: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + 10), to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y - 10)), lineWidth: 3.0))
            
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
