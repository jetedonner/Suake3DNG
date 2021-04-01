//
//  ArrowCtrl.swift
//  Suake3D
//
//  Created by Kim David Hauser on 20.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class ArrowCtrl: SKNode {
    
    let arrowMgr:ArrowManager
    var imgArrow:SKSpriteNode!
    var lblArrow:SKLabelNode!
    let dir:SuakeDir
    let fadeShowHide:Bool = true
    let arrowAlpha:CGFloat = 0.65
    
    override var isPaused: Bool{
        get{ return self.isPaused }
        set{
            super.isPaused = newValue
            self.imgArrow.isPaused = newValue
            self.lblArrow.isPaused = newValue
        }
    }
    
    override var isHidden: Bool{
        get{ return super.isHidden }
        set{
            super.isHidden = newValue
            if(self.fadeShowHide){
                self.fadeArrowCtrl(fadeIn: !newValue)
            }else{
                self.imgArrow.isHidden = newValue
                self.lblArrow.isHidden = newValue
            }
        }
    }
    
    func fadeArrowCtrl(fadeIn:Bool = true){
        var fadeAct:SKAction = SKAction.fadeIn(withDuration: 0.0)
        if(!fadeIn){
            fadeAct = SKAction.fadeOut(withDuration: 1.0)
        }
        self.imgArrow.run(fadeAct, completion: {
//            super.isHidden = !fadeIn
//            self.imgArrow.isHidden = !fadeIn
        })
        self.lblArrow.run(fadeAct, completion: {
//            self.lblArrow.isHidden = !fadeIn
        })
    }
    
    func setPosition(position:CGPoint, reposX:CGFloat, reposY:CGFloat){
        self.imgArrow.position = position
        
        if(dir == .LEFT || dir == .RIGHT){
            self.imgArrow.position.x += reposX
        }else if(dir != .UP){
            self.imgArrow.position.y += reposY
        }
        
        self.lblArrow.position = position
        self.lblArrow.position.x += reposX
        self.lblArrow.position.y += reposY
    }
    
    func setDistLable(newDist:Double){
        if(self.isHidden){
            return
        }
        
        var dist = newDist
        if(dist < 0){
            dist *= -1
        }
        lblArrow.text = dist.format(f: Double.INTEGER_NO_DECIMAL_FORMAT)
    }
    
    init(arrowMgr:ArrowManager, dir:SuakeDir = .UP, origNode:SKSpriteNode? = nil) {
        self.arrowMgr = arrowMgr
        self.dir = dir
        super.init()
        
        if(origNode != nil){
            self.imgArrow = origNode?.copy() as? SKSpriteNode
            self.imgArrow.zPosition = 1000
            self.imgArrow.alpha = self.arrowAlpha
            if(dir == .DOWN){
                self.imgArrow.zRotation = CGFloat(Float.pi)
            }else if(dir == .LEFT){
                self.imgArrow.zRotation = CGFloat(Float.pi) / 2
            }else if(dir == .RIGHT){
                self.imgArrow.zRotation = CGFloat(Float.pi) / -2
            }
        }else{
            self.imgArrow = SKSpriteNode()
            self.imgArrow.texture = SKTexture(imageNamed: "art.scnassets/overlays/gameplay/icons/ArrowYellow64x64.png")
        }
        
        self.imgArrow.isHidden = false
        self.addChild(self.imgArrow)
        
        self.lblArrow = SKLabelNode()
        self.lblArrow.fontName = SuakeVars.defaultFontName
        self.lblArrow.fontSize = 24.0
        self.addChild(self.lblArrow)
        self.alpha = self.arrowAlpha
        
        self.arrowMgr.bgNode.addChild(self)
    }
    
    func addZoomInOutAction(){
        self.imgArrow.removeAllActions()
        self.imgArrow.isPaused = false
        let zoomAction:SKAction = SKAction.scale(by: 1.15, duration: 0.65)
        self.imgArrow.run(SKAction.repeatForever(SKAction.sequence([zoomAction, zoomAction.reversed()])))
    }
    
    func initArrowCtrl() {
        self.lblArrow.zRotation = 0.0
        self.addZoomInOutAction()
    }
    
    func rotate(duration:TimeInterval, dif:CGFloat, difX:CGFloat = 0.0, angle:CGFloat = CGFloat.pi / -2){
        self.rotateArrow(duration: duration, dif: dif, difX: difX)
        self.rotateLable(duration: duration, dif: dif, difX: difX, angle: angle)
    }
    
    func rotateArrow(duration:TimeInterval, dif:CGFloat, difX:CGFloat = 0.0){
        let act:SKAction =  SKAction.moveBy(x: difX, y: dif, duration: duration)
        act.timingMode = .easeInEaseOut
        self.imgArrow.run(SKAction.group([act]))
    }
    
    func rotateLable(duration:TimeInterval, dif:CGFloat, difX:CGFloat = 0.0, angle:CGFloat = CGFloat.pi / -2){
        let act3:SKAction =  SKAction.moveBy(x: difX, y: dif, duration: duration)
        act3.timingMode = .easeInEaseOut
        
        let act4:SKAction =  SKAction.rotate(byAngle: angle, duration: duration)
        act4.timingMode = .easeInEaseOut
        
        self.lblArrow.run(SKAction.group([act3, act4]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
