//
//  HUDOverlay.swift
//  Suake3D
//
//  Created by Kim David Hauser on 13.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class HUDOverlayScene: SuakeBaseOverlay {

    let lblSuakePosition:SKLabelNode = SKLabelNode(fontNamed: "DpQuake")
    let lblGoodyPosition:SKLabelNode = SKLabelNode(fontNamed: "DpQuake")
    let lblGameTimer:SKLabelNode = SKLabelNode(fontNamed: "DpQuake")
    let lblScore:SKLabelNode = SKLabelNode(fontNamed: "DpQuake")

    var crosshairEntity:CrosshairEntity!
    var hudEntity:HUDOverlayEntity!
    var map:MapOverlay!
    
    var arrows:ArrowManager!
    
    override init(size: CGSize) {
        super.init(size: size)
        self.sceneNode = self.scene
    }
    
    convenience init(game:GameController, hudEntity:HUDOverlayEntity) {
        
        self.init(size: (game.scnView.window?.frame.size)!)
        
        self.game = game
        self.hudEntity = hudEntity
        
        self.crosshairEntity = CrosshairEntity(game: game)
        self.crosshairEntity.isHidden = true
        
        self.sceneNode = self.scene
        
        self.map = MapOverlay(game: game, hud: self)
//        self.arrows = ArrowManager(game: game, hud: self)

        self.lblSuakePosition.text = "0 : 0"
        self.lblSuakePosition.position = CGPoint(x: frm.width / 2, y: (frm.height - self.lblSuakePosition.frame.height - 20))
        self.scene?.addChild(self.lblSuakePosition)
        
        self.lblGoodyPosition.fontSize = 16.0
        self.lblGoodyPosition.text = "-3 : 3"
        self.lblGoodyPosition.position = CGPoint(x: frm.width / 2, y: (frm.height - self.lblSuakePosition.frame.height - self.lblSuakePosition.frame.height - 20))
        self.scene?.addChild(self.lblGoodyPosition)
        
        self.setGameTimer(time: self.game.levelManager.currentLevel.levelConfigEnv.duration.rawValue)
        self.lblGameTimer.position = CGPoint(x: self.lblGameTimer.frame.width, y: (frm.height - self.lblGameTimer.frame.height - 20))
        self.scene?.addChild(self.lblGameTimer)
        
        
        self.lblScore.text = "0000"
        self.lblScore.position = CGPoint(x: frm.width - self.lblScore.frame.width , y: (frm.height - self.lblScore.frame.height - 20))
        self.scene?.addChild(self.lblScore)
        
        self.map.updateMap()
        
        self.arrows = ArrowManager(game: game, hud: self)
        self.arrows.showArrows = (SuakeVars.showArrows ? .DIR : .NONE)
//        self.arrows.setupArrows(hud: self)
    }
    
    func loadInitialValues(){
        self.setPositionTxt(pos: self.game.playerEntityManager.ownPlayerEntity.pos)
//        self.lblSuakePosition.text = // "0 : 0"
//        self.lblGoodyPosition.text = "-3 : 3"
        self.setGoodyPositionTxt(pos: self.game.playerEntityManager.goodyEntity.pos)
        
        self.setGameTimer(time: self.game.levelManager.currentLevel.levelConfigEnv.duration.rawValue)
        self.lblScore.text = "0000"
        self.map.updateMap(byPassCheck: true)
    }
    
    override func showOverlayScene() {
        self.arrows.showHideHelperArrows()
        if(self.game.stateMachine.currentState is SuakeStateReadyToPlay){
            self.map.zoomMap(zoomOn: false)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!self.crosshairEntity.mgCrosshairComponent.inited){
            _ = self.crosshairEntity.mgCrosshairComponent.drawAndGetCrosshairNG()
            self.crosshairEntity.addToHUD(hud: self)
        }
        
        if(self.game.stateMachine.currentState is SuakeStatePlaying){
            if(self.game.physicsHelper.deltaTime >= 1.0){
                self.arrows.showHideHelperArrows()
            }
        }
        
        //TODO: Move TO SUAKESTATEPLAYING
        for healthBar in self.hudEntity.healthBars{
//            if(!healthBar.value.node.isHidden){
                healthBar.value.drawHealthBar()
                self.reposHealthBar(healthBar: healthBar.value, entity: healthBar.key)
//            }
        }
        
//        self.map.updateMap()
        if(self.game.cameraHelper.fpv){
            self.checkAndAnimateCrosshairAimedAt()
        }
    }
    
    var overrideCheckIsAimedClass:Bool = false
    func checkAndAnimateCrosshairAimedAt(overrideCheckIsAimed:Bool = false){
//        let panCam:PanCameraHelper = self.game.panCameraHelper
        self.game.panCameraHelper.checkAimedAtAll(overrideCheckIsAimed: self.overrideCheckIsAimedClass)
        if(self.overrideCheckIsAimedClass){
           self.overrideCheckIsAimedClass = false
        }
    }
    
    func reposHealthBar(healthBar:HUDHealthBarOnScreenComponent, entity:SuakeBaseNodeEntity){
        
        if(!healthBar.healthBarInited){
            healthBar.drawHealthBar()
        }
        
        var posEntity:SCNVector3!
        if(entity is SuakeOwnPlayerEntity){
            let camPos:SCNVector3 = self.game.cameraHelper.cameraNodeFP.position
            posEntity = SCNVector3(camPos.x, camPos.y + 20, camPos.z)
        }/*else if(entity is SuakeOppPlayerEntity){
            let camPos:SCNVector3 = self.game.cameraHelper.cameraNodeFPOpp.position
            posEntity = SCNVector3(camPos.x, camPos.y + 40, camPos.z)
        }*/else{
            posEntity = SCNVector3(entity.position.x, entity.position.y + 40, entity.position.z)
        }
        let pos2D:SCNVector3 = self.game.scnView.projectPoint(posEntity)
        
        if(pos2D.z < 1.0 && pos2D.z > 0.5){
            healthBar.node.isHidden = false
            self.setHealthBarOppPos(healthBar: healthBar, pos: pos2D)
        }else{
            healthBar.node.isHidden = true
        }
    }
    
    func setHealthBarOppPos(healthBar:HUDHealthBarOnScreenComponent, pos:SCNVector3){
        healthBar.node.position = CGPoint(x: pos.x /*- (self.game.gameWindowSize.width / 2)*/ - (SuakeVars.HEALTHBAR_WIDTH_OPP / 2), y: pos.y  /*- (self.game.gameWindowSize.height / 2)*/ + 40)
    }
    
    
    func setScore(score:Int){
        self.lblScore.text = "\(String(withInt: score, leadingZeros: 4))"
    }
    
    func setGameTimer(time:TimeInterval){
        self.lblGameTimer.text = "\(time.format(using: [.minute, .second])!)"
    }
    
    func setPositionTxt(pos:SCNVector3){
        self.lblSuakePosition.text = Int(pos.x).description + " : " + Int(pos.z).description
    }
    
    func setGoodyPositionTxt(pos:SCNVector3){
        self.lblGoodyPosition.text = Int(pos.x).description + " : " + Int(pos.z).description
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
