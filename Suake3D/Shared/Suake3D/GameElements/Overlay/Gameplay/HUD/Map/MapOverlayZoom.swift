//
//  MapOverlayZoom.swift
//  Suake3D
//
//  Created by Kim David Hauser on 19.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

extension MapOverlay{

    func toggleZoomMap() {
        self.zoomMap(zoomOn: !self.zoomOn)
    }
    
    func zoomMap(zoomOn: Bool, time:TimeInterval = 0.4, playSound:Bool = true) {
        guard self.game.overlayManager != nil else {
            return
        }
        
        self.game.overlayManager.hud.overlayScene.isPaused = false
        self.zoomOn = zoomOn
        let windowSize:CGSize = (self.game.scnView.window?.frame.size)!
        if(!zoomOn){
            if(playSound){
                self.game.soundManager.playSound(soundType: .zoomOut)
            }
            self.map.run(SKAction.group([SKAction.scale(to: self.zoomScaleFactor, duration: time), SKAction.moveTo(x: windowSize.width - 20 - (self.mapWidth / 2 * self.zoomScaleFactor), duration: time), SKAction.moveTo(y: 20 + (self.mapHeight / 2 * self.zoomScaleFactor), duration: time)]))
        }else{
            if(playSound){
                self.game.soundManager.playSound(soundType: .zoomIn)
            }
            self.map.run(SKAction.group([SKAction.scale(to: 1.0, duration: time), SKAction.moveTo(x: self.originalPos.x, duration: time), SKAction.moveTo(y: self.originalPos.y, duration: time)]))
        }
    }
}
