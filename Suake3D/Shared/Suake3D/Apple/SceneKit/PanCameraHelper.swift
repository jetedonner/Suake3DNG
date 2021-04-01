//
//  PanCameraHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 18.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class PanCameraHelper: SuakeGameClass {
    
    let F = SCNFloat(0.005)
    let rotXDiffMax:CGFloat = 0.04
    var diffX:Float = 0.0
    var diffY:Float = 0.0
    
    var _cameraNodeFPDegrees:Double = 180.0
    var cameraNodeFPDegrees:Double{
        get {
            var result:Double = 100.0
//            nameQueue.sync {
                result = self._cameraNodeFPDegrees
//            }
            return result
        }
        set {
//            nameQueue.async(flags: .barrier) {
                self._cameraNodeFPDegrees = newValue
//            }
        }
    }
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func panCamera(_ direction: SIMD2<Float>) {
        if(self.game.stateMachine.currentState is SuakeStateReadyToPlay || self.game.stateMachine.currentState is SuakeStatePlaying){

            self.diffX = direction.x
            self.diffY = direction.y
//               if (self.diffX == 0 && self.diffY == 0){
//                   return
//               }
//                var directionToPan = direction
//                #if os(iOS) || os(tvOS)
//                directionToPan *= float2(1.0, -1.0)
//                #endif
                
                let viewNode = self.game.scnView.pointOfView
                viewNode?.isPaused = false
                var rotX:CGFloat = SCNFloat(direction.y) * -F
                if((viewNode!.eulerAngles.x > CGFloat.pi * (1.0 + self.rotXDiffMax) && rotX > 0) || (viewNode!.eulerAngles.x < CGFloat.pi * (1.0 - self.rotXDiffMax) && rotX < 0)){
                    rotX = 0.0
//                    return
                }
                let rotY:CGFloat = CGFloat(direction.x) * F
                viewNode!.runAction(SCNAction.rotateBy(x: 0/*rotX*/, y: rotY, z: 0, duration: 0.0), completionHandler: {
                    let degrees = viewNode!.eulerAngles.y * CGFloat(180 / Double.pi)
                    
                    print("Rotate view by: \(rotY), to: \(viewNode!.eulerAngles.y) (Deg: \(degrees)")
                    
//                    degrees -= 180
                    var deg:Double = Double(degrees)
                    deg = deg.truncatingRemainder(dividingBy: 360)
                    if(deg <= 0.0){
                        deg += 360.0
                    }
                    if(deg >= -1 && deg <= 0){
                        deg = 0.0
                    }
                    self.cameraNodeFPDegrees = deg
                    
//                    if(self.game.overlayManager.hud.hudEntity.crosshairEntity.currentWeaponType == .sniperrifle){
//                        self.game.overlayManager.hud.hudEntity.crosshairEntity.sniperrifleCrosshairComponent.setAngelLbl(angel: CGFloat(deg))
//                    }
                })
//            }
        }
    }
    
    @discardableResult
    public func checkAimedAtAll(overrideCheckIsAimed:Bool = false)->Bool{
        var bRet:Bool = false
        var centerPnt:CGPoint = CGPoint(x: (self.game.gameWindowSize.width / 2), y: (self.game.gameWindowSize.height / 2))
        centerPnt.y -= 10.0
        
        let hitTestCategoryBitMask:CollisionCategory = self.getHitTestCatBitMask()
        
        let options = [SCNHitTestOption.backFaceCulling: false, SCNHitTestOption.firstFoundOnly: false, SCNHitTestOption.ignoreHiddenNodes: false, SCNHitTestOption.clipToZRange: false, SCNHitTestOption.categoryBitMask: hitTestCategoryBitMask.rawValue as Any]

        let results = self.game.scnView.hitTest(centerPnt, options: options)
        bRet = (results.count > 0)
        self.animation4AimedAtPoint(isAimedAtSomething: bRet)
        return bRet
    }
    
    var isAimedAt:Bool = false
    func animation4AimedAtPoint(isAimedAtSomething:Bool){
        if(isAimedAtSomething){
            if(!isAimedAt){
                self.isAimedAt = true
                self.game.showDbgMsg(dbgMsg: "AIMED at Point", dbgLevel: .Verbose)
                self.game.overlayManager.hud.overlayScene.crosshairEntity.currentCrosshairComponent.animCS = false
                self.animateCrosshair(animationIn: true)
            }
        }else{
            if(isAimedAt){
                self.isAimedAt = false
                self.game.showDbgMsg(dbgMsg: "NOT AIMED at Point", dbgLevel: .Verbose)
                self.game.overlayManager.hud.overlayScene.crosshairEntity.currentCrosshairComponent.animCS = true
                self.animateCrosshair(animationIn: false)
            }
        }
    }
    
    func animateCrosshair(animationIn:Bool = true, override:Bool = false){
        if(self.game.overlayManager.hud.overlayScene.crosshairEntity.currentCrosshairComponent.animatedIn != animationIn || override){
            
            self.game.overlayManager.hud.overlayScene.crosshairEntity.currentCrosshairComponent.animatedIn = animationIn
            self.game.showDbgMsg(dbgMsg: "Animating crosshair to: " + (animationIn ? "IN" : "OUT"), dbgLevel: .Verbose)
            self.game.overlayManager.hud.overlayScene.crosshairEntity.currentCrosshairComponent.animateCrosshair(animated: !animationIn)
        }
    }
    
    func getHitTestCatBitMask()->CollisionCategory{
        var hitTestCat:CollisionCategory = CollisionCategory()
        //var hitTestCategoryBitMask:Int = 0
//        if(DbgVars.startLoad_MediPacks){
//            for i in 0..<self.game.medKits.itemEntityManager.medKitEntities.count{
//                if(self.checkNodeInsideFrustum(node: (self.game.medKits.itemEntityManager.getItemEntity(itemType: .MedKit, id: i)?.medKitComponent.node)!)){
//                    hitTestCategoryBitMask = hitTestCategoryBitMask | CollisionCategory.medKit.rawValue
//                    break
//                }
//            }
//        }
        if(DbgVars.startLoad_Goody){
            if(self.checkNodeInsideFrustum(node: self.game.playerEntityManager.goodyEntity.goodyComponent.node)){
                hitTestCat.insert(.goody)
                //CollisionCategory.init(categories: [.goody])
                //hitTestCategoryBitMask = hitTestCategoryBitMask | CollisionCategory.goody.rawValue
            }
        }
//
//        if(DbgVars.startLoad_Droids){
//            if(self.checkNodeInsideFrustum(node: self.game.playerEntityManager.getDroidEntity().droidComponent.node)){
//                hitTestCategoryBitMask = hitTestCategoryBitMask | CollisionCategory.droid.rawValue
//            }
//        }
//        if(DbgVars.startLoad_Opponent){
//            if(self.checkNodeInsideFrustum(node: (self.game.playerEntityManager.getOppPlayerEntity()?.currentSuakeComponent.node)!)){
//                hitTestCategoryBitMask = hitTestCategoryBitMask | CollisionCategory.suakeOpp.rawValue
//            }
//        }
        return hitTestCat
    }
    
    func checkNodeInsideFrustum(node:SCNNode)->Bool{
        return self.game.scnView.isNode(node.presentation, insideFrustumOf: self.game.scnView.pointOfView!.presentation)
    }
}
