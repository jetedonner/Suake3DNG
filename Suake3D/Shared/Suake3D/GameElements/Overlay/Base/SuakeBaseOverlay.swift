//
//  SuakeBaseOverlay.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit
import GameplayKit

class SuakeBaseOverlay: SKScene {
    
    var game:GameController!
    var overlayType:OverlayType!
    var lastUpdateTimeInterval: CFTimeInterval = 0
    var sceneNode:SKScene!
    let frm:CGRect
    
    var _isLoaded:Bool = false
    var isLoaded:Bool{
        get{ return self._isLoaded }
        set{ self._isLoaded = newValue }
    }

    convenience init(game:GameController) {
        self.init(size: game.scnView.window!.frame.size)
        self.game = game
    }
    
    override init(size: CGSize) {
        self.frm = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        super.init(size: size)
    }
    
    func showOverlayScene(){
        
    }
    
    func mouseMovedHandler(with event: NSEvent) {
    
    }
        
    func mouseDownHandler(in view: NSView, with event: NSEvent) -> Bool {
        return false
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
