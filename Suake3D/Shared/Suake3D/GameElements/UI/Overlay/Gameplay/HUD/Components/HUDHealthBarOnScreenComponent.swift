//
//  HUDOtherHealthBarComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 27.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class HUDHealthBarOnScreenComponent: BaseHUDComponent {
    
    var hud:HUDOverlayScene!
    
    let healthBarNode:SKNode = SKNode()
    var healthBarLable:SKLabelNode = SKLabelNode()
    var healthBarShapeNode:SKShapeNode = SKShapeNode()
    var healthBarShapeNodeInner:SKShapeNode = SKShapeNode()
    var healthBarInited:Bool = false
    let playerType:SuakePlayerType
    let id:Int
    var text:String = ""
    let color:NSColor
    
    var isHidden:Bool{
        get{ return self.node.isHidden }
        set{
            self.node.isHidden = newValue
        }
    }
    
    init(game:GameController, playerType:SuakePlayerType = .OppSuake, id:Int = 0) {
        self.playerType = playerType
        self.color = (self.playerType == .Goody ? NSColor.cyan : NSColor.green)
        self.id = id
        super.init(game: game, node: healthBarNode)
    }
    
    func setupHealthBar(hud:HUDOverlayScene){
        self.hud = hud
        self.hud.scene?.addChild(self.node)
    }
    
    func initLabel(){
        self.healthBarLable.removeFromParent()
        self.healthBarLable.fontName = SuakeVars.defaultFontName
        self.healthBarLable.fontSize = 18.0
        self.setText()
    }
    
    func getEntityTextPrefix()->String{
        var sRet:String = ""
        switch self.playerType {
            case .OwnSuake:
//                if(self.game.playerEntityManager.getOppPlayerEntity() != nil){
//                    sRet = self.game.playerEntityManager.getOppPlayerEntity()!.enemyName.rawValue
//                }else{
//                    sRet = "Opponent"
//                }
                    sRet = "You"
                break
            case .OppSuake:
//                if(self.game.playerEntityManager.getOppPlayerEntity() != nil){
                    sRet = self.game.playerEntityManager.oppPlayerEntity.enemyName.rawValue
//                }else{
//                    sRet = "Opponent"
//                }
//                break
            case .Droid:
                sRet = "Droid " + (self.id + 1).description
                break
            case .Goody:
                sRet = "Goody"
                break
            default:
                sRet = "(Default)"
        }
        return sRet
    }
    
    func setText(){
        let name:String = self.getEntityTextPrefix()
        self.healthBarLable.text = name + ": " + self.getHealthPercent().description + "%"
    }
    
    func initUpdateHealthBar(health:CGFloat){
        if(health > 0.0){
//            ArraySync.sync(lock: health as NSObject, closure: {
                self.healthBarShapeNode.removeFromParent()
                self.healthBarShapeNodeInner = SKShapeNode()
                var currentColor:NSColor = self.color
                if(health > 50){
                    var yellowAlpha = Double(1.0 - ((health - 50) / 100))
                    if(yellowAlpha < 0.0){
                        yellowAlpha = 0.0
                    }
                    var greenAlpha = Double(((health - 50) / 100))
                    if(greenAlpha > 1.0){
                        greenAlpha = 1.0
                    }
                    currentColor = (NSColor.yellow * yellowAlpha) + (currentColor * greenAlpha)
                }else{
                    currentColor = NSColor.red * Double(1.0 - (health * 2 / 100)) + NSColor.yellow * Double(health * 2 / 100)
                }
                
                self.healthBarShapeNode.strokeColor = currentColor
                self.healthBarShapeNodeInner.fillColor = currentColor
                self.healthBarShapeNodeInner.strokeColor = currentColor
                if(health > 0.0){
                    let healthBarPathInner:CGMutablePath = CGMutablePath()
                    
                    let healthBarWidth:CGFloat = SuakeVars.HEALTHBAR_WIDTH_OPP * (health / 100)
                    let healthBarHeight:CGFloat = SuakeVars.HEALTHBAR_HEIGHT_OPP
                    
                    var cornerWidth:CGFloat = SuakeVars.HEALTHBAR_HEIGHT_OPP / 2
                    
                    if(cornerWidth * 2 >= healthBarWidth){
                        cornerWidth = (healthBarWidth / 2) - 0.01
                    }
                    
                    let cornerHeight:CGFloat = (health > 0.0 ? SuakeVars.HEALTHBAR_HEIGHT_OPP / 2 : 0)
                    
                    healthBarPathInner.addRoundedRect(in: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: healthBarWidth, height: healthBarHeight)), cornerWidth: cornerWidth, cornerHeight: cornerHeight)
                    
                    self.healthBarShapeNodeInner.path = healthBarPathInner
                    self.healthBarShapeNodeInner.alpha = 1.0
                    self.healthBarShapeNodeInner.name = "HealthBarInner"
                    self.healthBarShapeNodeInner.zPosition = 0
                    self.healthBarShapeNode.zPosition = 1
                    self.node.addChild(self.healthBarShapeNodeInner)
                }
                self.node.addChild(self.healthBarShapeNode)
//            })
        }
    }
    
    func updateHealthBar(){
        DispatchQueue.main.async {
            self.node.removeAllChildren()
            self.healthBarShapeNodeInner.removeFromParent()
            self.initUpdateHealthBar(health: self.getHealthPercent())
            self.initLabel()
        }
    }
    
    func getHealthPercent()->CGFloat{
        var healthPercent:CGFloat = 100.0
        if(self.playerType == .OwnSuake){
            healthPercent = self.game.playerEntityManager.ownPlayerEntity.healthComponent.health
        }else if(self.playerType == .OppSuake){
            healthPercent = self.game.playerEntityManager.oppPlayerEntity.healthComponent.health
        }else if(self.playerType == .Goody){
            healthPercent = self.game.playerEntityManager.goodyEntity.healthComponent.health
        }else if(self.playerType == .Droid){
            healthPercent = self.game.playerEntityManager.droidEntities[self.id].healthComponent.health
        }/*else if(self.playerType == .Droid){
            healthPercent = self.game.playerEntityManager.getDroidEntity(id: self.id).healthComponent.health
        }else if(self.playerType == .OppSuake && self.game.playerEntityManager.getOppPlayerEntity() != nil){
            healthPercent = self.game.playerEntityManager.getOppPlayerEntity()!.healthComponent.health
        }*/
        return healthPercent
    }
    
    func decHealth(){
        self.updateHealthBar()
    
    }
    
    func drawHealthBar(){
//        if(self.isHidden){
//            return
//        }
        if(!healthBarInited){
            healthBarInited = true
        }else{
            self.healthBarShapeNodeInner.removeFromParent()
            self.healthBarShapeNode.removeFromParent()
        }
        self.initLabel()
        
        let healthPercent:CGFloat = self.getHealthPercent()
        var width:CGFloat = SuakeVars.HEALTHBAR_WIDTH
        var height:CGFloat = SuakeVars.HEALTHBAR_HEIGHT
    
        width = SuakeVars.HEALTHBAR_WIDTH_OPP
        height = SuakeVars.HEALTHBAR_HEIGHT_OPP

        let currentColor:NSColor = NSColor.red * Double(1.0 - (healthPercent / 100)) + self.color * Double(healthPercent / 100)
        
        healthBarShapeNode.strokeColor = color

        let mapPath:CGPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height)), cornerWidth: height/8, cornerHeight: height/8, transform: nil)
        
        healthBarShapeNode.path = mapPath
        healthBarShapeNode.lineWidth = 1.0
        healthBarShapeNode.alpha = 1.0
        healthBarShapeNode.name = "HealthBar"
        
        healthBarShapeNodeInner.fillColor = currentColor
        healthBarShapeNodeInner.strokeColor = currentColor
                
        let mapPathInner:CGPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width * (healthPercent / 100), height: height)), cornerWidth: height/8, cornerHeight: height/8, transform: nil)
        
        healthBarShapeNodeInner.path = mapPathInner
        healthBarShapeNodeInner.alpha = 1.0
        healthBarShapeNodeInner.name = "HealthBarInner " + (self.playerType == .Droid ? "Droid" :  "Opponent")
        healthBarShapeNodeInner.zPosition = 0
        healthBarShapeNode.zPosition = 1
        
        self.healthBarLable.position.y = 0
        self.healthBarLable.position.x = 0
        self.healthBarLable.position.y += 15
        self.healthBarLable.position.x += (healthBarShapeNode.frame.width / 2)
        self.node.addChild(healthBarShapeNodeInner)
        self.node.addChild(healthBarShapeNode)
        self.node.addChild(healthBarLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
