//
//  ArrowManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 14.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit
import NetTestFW

public enum ArrowsShowState:Int{
    case NONE = 0, DIR = 1, ALL = 2
}

class ArrowManager: SuakeGameClass {
    
    let hud:HUDOverlayScene
    
    var arrowUp:ArrowCtrl!
    var arrowDown:ArrowCtrl!
    var arrowLeft:ArrowCtrl!
    var arrowRight:ArrowCtrl!
    
    var arrows:[ArrowCtrl]!
    
    var _showArrows:ArrowsShowState = .DIR
    var showArrows:ArrowsShowState{
        get{ return self._showArrows }
        set{
            self._showArrows = newValue
            self.showHideHelperArrows()
        }
    }
    
    let bgNode:SKSpriteNode = SKSpriteNode()
    var widthHeightDif:CGFloat!
    
    let lblRepos:CGFloat = 30
    let lblOffset:CGFloat = 90
    let lblArrowCountDist:CGFloat = 60.0
    
    init(game: GameController, hud:HUDOverlayScene) {
        self.hud = hud
        super.init(game: game)
        
        self.setupArrowsOnHUD()
        self.updateWidthHeightDif()
    }
    
    func initArrowPosition(){
        self.arrowDir = .UP
        self.updateWidthHeightDif()
        self.reposArrows()
        self.bgNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.0))
        
        for arrow in self.arrows{
            arrow.initArrowCtrl()
        }
    }
    
    func getNewArrowDir(turnDir:TurnDir = .Left)->SuakeDir{
        if(arrowDir == .UP && turnDir == .Left || arrowDir == .DOWN && turnDir == .Right){
            return .LEFT
        }else if(arrowDir == .LEFT && turnDir == .Left || arrowDir == .RIGHT && turnDir == .Right){
            return .DOWN
        }else if(arrowDir == .DOWN && turnDir == .Left || arrowDir == .UP && turnDir == .Right){
            return .RIGHT
        }else if(arrowDir == .RIGHT && turnDir == .Left || arrowDir == .LEFT && turnDir == .Right){
            return .UP
        }else{
            return .UP
        }
    }
    
    func updateWidthHeightDif(){
        self.widthHeightDif = (self.game.gameWindowSize.width - self.game.gameWindowSize.height) / 2
    }
    
    func translateArrowDir2SuakeDir(arrowDir:SuakeDir)->SuakeDir{
        if(arrowDir == .UP && self.arrowDir == .UP){
            return .UP
        }else if(arrowDir == .DOWN && self.arrowDir == .UP){
            return .DOWN
        }else if(arrowDir == .LEFT && self.arrowDir == .UP){
            return .LEFT
        }else if(arrowDir == .RIGHT && self.arrowDir == .UP){
            return .RIGHT
        }else{
            return self.arrowDir
        }
    }
    
    func rotateArrow(arrow:SKSpriteNode, dif:CGFloat, difX:CGFloat = 0.0){
        let act:SKAction =  SKAction.moveBy(x: difX, y: dif, duration: SuakeVars.gameStepInterval)
        act.timingMode = .easeInEaseOut
        arrow.run(SKAction.group([act]))
    }
    
    func rotateLable(lable:SKLabelNode, dif:CGFloat, difX:CGFloat = 0.0, angle:CGFloat = CGFloat.pi / -2){
        let act3:SKAction =  SKAction.moveBy(x: difX, y: dif, duration: SuakeVars.gameStepInterval)
        act3.timingMode = .easeInEaseOut
        
        let act4:SKAction =  SKAction.rotate(byAngle: angle, duration: SuakeVars.gameStepInterval)
        act4.timingMode = .easeInEaseOut
        
        lable.run(SKAction.group([act3, act4]))
    }
    
    var arrowDir:SuakeDir = .UP
    func rotateArrows(duration:TimeInterval, turnDir:TurnDir = .Left){
        
        self.updateWidthHeightDif()
        let newArrowDir:SuakeDir = self.getNewArrowDir(turnDir: turnDir)
        
        let rotation:CGFloat = (turnDir == .Left ? 2 : -2)
        self.bgNode.run(SKAction.rotate(byAngle: CGFloat.pi / rotation, duration: duration))
  
        let dif:CGFloat = ((newArrowDir == .UP || newArrowDir == .DOWN) ? -self.widthHeightDif : self.widthHeightDif)
        
        arrowUp.rotate(duration: duration, dif: dif, angle: CGFloat.pi / -rotation)
        arrowDown.rotate(duration: duration, dif: -dif, angle: CGFloat.pi / -rotation)
        arrowLeft.rotate(duration: duration, dif: 0.0, difX: dif, angle: CGFloat.pi / -rotation)
        arrowRight.rotate(duration: duration, dif: 0.0, difX: -dif, angle: CGFloat.pi / -rotation)
        self.arrowDir = newArrowDir
    }
    
    func setupArrowsOnHUD(){
//        let origArrowLbl:SKLabelNode = SKLabelNode(fontNamed: "DpQuake")
        let origArrow:SKSpriteNode = SKSpriteNode(imageNamed: "art.scnassets/overlays/gameplay/icons/ArrowOrangeTransPlanb64x64rot.png")
        
        self.arrowUp = ArrowCtrl(arrowMgr: self, dir: .UP, origNode: origArrow)
        self.arrowDown = ArrowCtrl(arrowMgr: self, dir: .DOWN, origNode: origArrow)
        self.arrowLeft = ArrowCtrl(arrowMgr: self, dir: .LEFT, origNode: origArrow)
        self.arrowRight = ArrowCtrl(arrowMgr: self, dir: .RIGHT, origNode: origArrow)
        
        self.arrows = [self.arrowUp, self.arrowDown/*, self.arrowLeft*/, self.arrowRight]
        
        self.reposArrows()
        bgNode.position = CGPoint(x: self.game.gameWindowSize.width / 2, y: self.game.gameWindowSize.height / 2)
        self.hud.addChild(bgNode)
        
        for arrow in self.arrows{
            arrow.isPaused = false
        }
    }
    
    func reposArrows() {
        self.arrowUp.setPosition(position: CGPoint(x: 0, y: (self.game.gameWindowSize.height / 2) - self.lblOffset - (self.arrowUp.imgArrow.frame.height / 2)), reposX: lblArrowCountDist, reposY: -lblRepos)
        
        self.arrowDown.setPosition(position: CGPoint(x: 0, y: (self.game.gameWindowSize.height / -2) + self.lblOffset + (self.arrowDown.frame.height / 2)), reposX: lblArrowCountDist, reposY: lblRepos)
        
        self.arrowLeft.setPosition(position: CGPoint(x: (self.game.gameWindowSize.width / -2) + self.lblOffset + (self.arrowLeft.imgArrow.frame.width / -2), y: self.arrowLeft.imgArrow.frame.height / 2), reposX: lblRepos, reposY: lblArrowCountDist)

        self.arrowRight.setPosition(position: CGPoint(x: (game.gameWindowSize.width / 2) - self.lblOffset - (self.arrowRight.imgArrow.frame.width / 2), y: (self.arrowRight.imgArrow.frame.height / 2)), reposX: -lblRepos, reposY: lblArrowCountDist)
    }
    
    func showHideHelperArrows(){
        let arrowUp:ArrowCtrl = self.arrowUp
        let arrowRight:ArrowCtrl = self.arrowRight
        let arrowDown:ArrowCtrl = self.arrowDown
        let arrowLeft:ArrowCtrl = self.arrowLeft

        self.setArrowsHiddedOrNot(arrowUp:arrowUp, arrowRight:arrowRight, arrowDown:arrowDown, arrowLeft:arrowLeft)
    }
    
    func setArrowsHiddedOrNot(arrowUp:ArrowCtrl, arrowRight:ArrowCtrl, arrowDown:ArrowCtrl, arrowLeft:ArrowCtrl){
        
        guard let ownPlayerEntity:SuakePlayerEntity = self.game.playerEntityManager.ownPlayerEntity else{
            return
        }
        
        guard let goodyEntity:GoodyEntity = self.game.playerEntityManager.goodyEntity else{
            return
        }
        
        let charPos:SCNVector3 = ownPlayerEntity.pos
        let godPos:SCNVector3 = goodyEntity.pos
        
        let hideArrowUp:Bool = (!((goodyEntity.pos.z > ownPlayerEntity.pos.z) && showArrows == .DIR)) && showArrows != .ALL
        arrowUp.isHidden = hideArrowUp
        arrowUp.setDistLable(newDist: Double(charPos.z - godPos.z))
        
        arrowRight.isHidden = (!((goodyEntity.pos.x < ownPlayerEntity.pos.x) && showArrows == .DIR)) && showArrows != .ALL
        arrowRight.setDistLable(newDist: Double(charPos.x - godPos.x))

        arrowDown.isHidden = (!((goodyEntity.pos.z < ownPlayerEntity.pos.z) && showArrows == .DIR)) && showArrows != .ALL
        arrowDown.setDistLable(newDist: Double(charPos.z - godPos.z))

        arrowLeft.isHidden = (!((goodyEntity.pos.x > ownPlayerEntity.pos.x) && showArrows == .DIR)) && showArrows != .ALL
        arrowLeft.setDistLable(newDist: Double(charPos.x - godPos.x))
    }
}
