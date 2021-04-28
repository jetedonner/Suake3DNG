//
//  Windrose.swift
//  Suake3D
//
//  Created by Kim David Hauser on 12.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit
import NetTestFW

class Windrose:BaseExtHUDComponent{
    
    var imgWindRose:SKSpriteNode = SKSpriteNode()
    var windRosePath:CGMutablePath = CGMutablePath()
    var windRose:SKShapeNode = SKShapeNode()
    let innerRadius: CGFloat = 350
    let outerRadius: CGFloat = 360
    let outerRadius2: CGFloat = 375
    let numTicks = 24
    
    var centerNode:SKNode = SKNode()
    var centerNodeGoodyPos:SKNode = SKNode()
    var imgRotation:SKSpriteNode!
    var imgGoodyPos:SKSpriteNode!
    
    var fadeShowHide:Bool = true
    override var isHidden: Bool{
        get{ return super.isHidden }
        set{
            if(self.fadeShowHide){
                self.fadeWindrose(fadeIn: !newValue)
            }else{
                super.isHidden = newValue
//                self.imgArrow.isHidden = newValue
//                self.lblArrow.isHidden = newValue
            }
        }
    }
    
    func fadeWindrose(fadeIn:Bool = true){
        var fadeAct:SKAction = SKAction.fadeIn(withDuration: 1.0)
        if(!fadeIn){
            fadeAct = SKAction.fadeOut(withDuration: 1.0)
        }
        self.windRose.run(fadeAct, completion: {
//            self.lblArrow.isHidden = !fadeIn
        })
        self.centerNode.run(fadeAct, completion: {
//            super.isHidden = !fadeIn
//            self.imgArrow.isHidden = !fadeIn
        })
        self.centerNodeGoodyPos.run(fadeAct, completion: {
//            self.lblArrow.isHidden = !fadeIn
        })
    }
    
    override init(game: GameController) {
        super.init(game: game)
        self.drawWindrose()
    }
    
    func setupWindrose(hud:HUDOverlayScene){
//        self.imgRotation = SKSpriteNode(  (hud.childNode(withName: "imgRotation") as! SKSpriteNode)
        self.imgRotation = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/icons/ArrowRedTransBlur72x72.png")
        
//        self.imgRotation.texture = SKTexture(imageNamed: "art.scnassets/overlays/gameplay/icons/ArrowRedTransBlur72x72.png")
//        self.imgRotation.removeFromParent()
        self.imgRotation.zPosition = 100003
        self.imgRotation.zRotation = CGFloat.pi / -2
        self.imgRotation.position.y += innerRadius
        self.centerNode.addChild(self.imgRotation)
        self.centerNode.position = CGPoint(x: self.game.gameWindowSize.width / 2, y: self.game.gameWindowSize.height / 2)
        //imgRotation.alpha = 0
        hud.addChild(self.centerNode)
        
        self.imgGoodyPos = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/icons/ArrowOrangeTransPlanb64x64.png") //= (hud.childNode(withName: "imgGoodyPos") as! SKSpriteNode)
//        self.imgGoodyPos.texture = SKTexture(imageNamed: "art.scnassets/overlays/gameplay/icons/ArrowOrangeTransPlanb64x64.png")
//        self.imgGoodyPos.removeFromParent()
        self.imgGoodyPos.zPosition = 100002
        self.imgGoodyPos.zRotation = CGFloat.pi / -2
        self.imgGoodyPos.position.y += innerRadius
        self.centerNodeGoodyPos.addChild(self.imgGoodyPos)
        self.centerNodeGoodyPos.position = CGPoint(x: self.game.gameWindowSize.width / 2, y: self.game.gameWindowSize.height / 2)
        hud.addChild(self.centerNodeGoodyPos)
        
        hud.addChild(self.imgWindRose)
    }
    
    func resetWindroseRotation(){
        self.windRose.run(SKAction.rotate(toAngle: 0.0, duration: 0.0))
        for lbl in self.windroseLbls{
            lbl.run(SKAction.rotate(toAngle: 0.0, duration: 0.0))
        }
    }
    
    func rotateWindrose(duration:TimeInterval, turnDir:TurnDir = .Left){
        if(turnDir == .Left){
            self.windRose.run(SKAction.rotate(byAngle: CGFloat.pi / 2, duration: duration))
            for lbl in self.windroseLbls{
                lbl.run(SKAction.rotate(byAngle: CGFloat.pi / -2, duration: duration))
            }
        }else{
            self.windRose.run(SKAction.rotate(byAngle: CGFloat.pi / -2, duration: duration))
            for lbl in self.windroseLbls{
                lbl.run(SKAction.rotate(byAngle: CGFloat.pi / 2, duration: duration))
            }
        }
        self.updateArrowGoodyPos()
    }

    func getLookAtRotation(_ point: SCNVector3)->SCNVector3{
        // Find change in positions
        let mePos:SCNVector3 = self.game.cameraHelper.cameraNodeFP.position
        let changeX = mePos.x - point.x // Change in X position
        let changeY = mePos.y - point.y // Change in Y position
        let changeZ = mePos.z - point.z // Change in Z position

        // Calculate the X and Y angles
        let angleX = atan2(changeZ, changeY) * (changeZ > 0 ? -1 : 1)
        let angleY = atan2(changeZ, changeX)

        // Calculate the X and Y rotations
        let xRot = (CGFloat.pi / -2) - angleX // X rotation
        let yRot = (CGFloat.pi / -2) - angleY // Y rotation
        //self.eulerAngles = SCNVector3(CGFloat(xRot), CGFloat(yRot), 0) // Rotate
        return SCNVector3(CGFloat(xRot), CGFloat(yRot), 0)
    }
    
    func updateArrowGoodyPos(){
        self.centerNodeGoodyPos.zRotation = self.windRose.zRotation + self.getLookAtRotation(self.game.playerEntityManager.goodyEntity.position).y // self.lookAtNode.eulerAngles.y * -1
        for lbl in self.windroseLbls{
            lbl.run(SKAction.rotate(toAngle: -self.windRose.zRotation, duration: 0.0))
        }
    }
    
    public func drawWindrose()->SKSpriteNode{
        
        let path = NSBezierPath()
        if(windRose.parent != nil){
            windRose.removeFromParent()
        }
        self.windRose = SKShapeNode()
        self.windRose.strokeColor = SuakeColors.MapGridBorderColor
        self.windRose.lineWidth = 4.0
        self.windRose.lineCap = .round
        self.windRose.name = "WindRose"
        
        for i:Int in 0..<(numTicks - 0)  {
            let angle = CGFloat(i) * CGFloat(2*Double.pi) / CGFloat(numTicks)
            let inner = CGPoint(x: innerRadius * cos(angle), y: innerRadius * sin(angle))
            var outer = CGPoint(x: outerRadius * cos(angle), y: outerRadius * sin(angle))
            if(Int(i) % 6 == 0){
                outer = CGPoint(x: outerRadius2 * cos(angle), y: outerRadius2 * sin(angle))
            }
            path.move(to: inner)
            path.line(to: outer)
        }
        self.windRose.path = path.cgPath
        self.windRose.zPosition = 1005
        
        drawWindRoseLabel(txt: "180" /*"0"*/, angleMult: /*18*/ 6, offsetX: 0, offsetY: 50, bold: true)
        drawWindRoseLabel(txt: "225" /*"45"*/, angleMult: /*21*/ 9, offsetX: 30, offsetY: 30)
        drawWindRoseLabel(txt: "270" /*"90"*/, angleMult: /*0*/ 12, offsetX: 50, offsetY: 0 - 16, bold: true)
        drawWindRoseLabel(txt: "315" /*"135"*/, angleMult: /*3*/ 15, offsetX: 30, offsetY: -30)
        drawWindRoseLabel(txt: "0" /*"180"*/, angleMult: /*6*/ 18, offsetX: 0, offsetY: -50, bold: true)
        drawWindRoseLabel(txt: "45" /*"225"*/, angleMult: /*9*/ 21, offsetX: -30, offsetY: -30)
        drawWindRoseLabel(txt: "90" /*"270"*/, angleMult: /*12*/ 0, offsetX: -50, offsetY: 0 - 16, bold: true)
        drawWindRoseLabel(txt: "135" /*"315"*/, angleMult: /*15*/ 3, offsetX: -50, offsetY: 30)
        
        self.imgWindRose.addChild(self.windRose)
        if(self.imgWindRose.parent != nil){
            self.imgWindRose.removeFromParent()
        }
        //self.addChild(imgWindRose)
        //imgWindRose.isHidden = true
        self.imgWindRose.position = CGPoint(x: self.game.gameWindowSize.width / 2, y: self.game.gameWindowSize.height / 2)
        return self.imgWindRose
    }
    
    var windroseLbls:[SKLabelNode] = [SKLabelNode]()
    
    private func drawWindRoseLabel(txt:String, angleMult:Int, offsetX:CGFloat, offsetY:CGFloat, bold:Bool = false){
        let lbl:SKLabelNode = SKLabelNode()
        lbl.text = txt + "°"
        lbl.fontName = "DpQuake"
        if(!bold){
            lbl.fontSize = 18.0
        }else{
            lbl.fontSize = 24.0
        }
        //       if(bold){
        //           lbl.fontName = lbl.fontName! + "-Bold"
        //       }
        let angle = CGFloat(-angleMult) * CGFloat(2*Double.pi) / CGFloat(numTicks)
        lbl.position = CGPoint(x: (innerRadius * cos(angle)) + offsetX, y: (innerRadius * sin(angle)) + offsetY)
        lbl.alpha = 0.55
        lbl.zPosition = 1005
        windroseLbls.append(lbl)
        self.windRose.addChild(lbl)
    }
    
//    func addBloom() -> [CIFilter]? {
//        let bloomFilter = CIFilter(name:"CIBloom")!
//        bloomFilter.setValue(5.0, forKey: "inputIntensity")
//        bloomFilter.setValue(3.0, forKey: "inputRadius")
//
//        return [bloomFilter]
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
