//
//  DroidComponentExt.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.03.21.
//

import Foundation
import SceneKit
import GameplayKit

extension DroidComponent{
    
    func changeDroidState(state:DroidState){
        let newColor:NSColor = ((state == .Attacking) ? NSColor.red : ((state == .Chasing) ? NSColor.orange : NSColor.green))
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.flashMaterial.diffuse.contents = newColor
        self.flashLightInner.light?.color = newColor
        if((state == .Attacking) || (state == .Chasing)){
            self.flashLightInner.removeAllAnimations()
            if(state == .Chasing){
                self.game.overlayManager.hud.overlayScene.map.droidNodes[self.id].setTexture(id: 1)
                self.flashLightInner.constraints?.removeAll()
                self.flashLightInner.eulerAngles = SCNVector3(-25, 0, 0)
                self.flashLightRotationAnimation.duration = 1.5
                self.flashLightInner.addAnimation(self.flashLightRotationAnimation, forKey: nil)
            }else{
                self.game.overlayManager.hud.overlayScene.map.droidNodes[self.id].setTexture(id: 2)
                let constraint = SCNLookAtConstraint(target: self.playerEntity.targetEntity.playerComponent.mainNode)
                constraint.isGimbalLockEnabled = false
                constraint.influenceFactor = 0.1
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.45
                self.flashLightInner.constraints = [constraint]
                SCNTransaction.commit()
            }
            self.flashLightInner.isHidden = false
        }else{
            if(self.game.overlayManager.hud.overlayScene.map.droidNodes.count > 0){
                self.game.overlayManager.hud.overlayScene.map.droidNodes[self.id].setTexture(id: 0)
            }
            self.flashLightInner.removeAllAnimations()
            self.flashLightInner.constraints?.removeAll()
            self.flashLightInner.eulerAngles = SCNVector3(-25, 0, 0)
            self.flashLightRotationAnimation.duration = 2.5
            self.flashLightInner.isHidden = false
            self.flashLightInner.addAnimation(self.flashLightRotationAnimation, forKey: nil)
        }
        SCNTransaction.commit()
        
        if(state == .Attacking){
            self.stopHeadAnimation()
        }else{
            self.playHeadAnimation()
        }
    }
    
}
