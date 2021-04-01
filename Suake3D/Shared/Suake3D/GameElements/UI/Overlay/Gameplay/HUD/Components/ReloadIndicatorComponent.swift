//
//  ReloadIndicatorComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 02.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class ReloadIndicatorComponent:BaseExtHUDComponent{

    var nodeReloadIndicator:SKShapeNode = SKShapeNode()
    let firstScaleAct:SKAction = SKAction.scaleX(to: 0.0, duration: 0.0)
    
    init(game: GameController, onHud:Bool = false) {
        super.init(game: game)
        _ = self.createReloadShape(onHud: onHud)
        self.nodeReloadIndicator.alpha = 0.0
    }
    
    public func resetReloadBar(){
        self.nodeReloadIndicator.removeAllActions()
        self.nodeReloadIndicator.run(SKAction.group([SKAction.fadeAlpha(to: 1.0, duration: 0.0), SKAction.scaleX(to: 1.0, duration: 0.0)]))
    }
        
    
    public func startReloadBar(duration:TimeInterval){
        
        self.nodeReloadIndicator.removeAllActions()
        self.nodeReloadIndicator.alpha = 1.0
        
        let secScaleAct:SKAction = SKAction.scaleX(to: 1.0, duration: duration)
        let secColorAct:SKAction = SKAction.customAction(withDuration: duration, actionBlock: {node,flt in
            let onePercent = duration / 100
            let curPercent = flt / CGFloat(onePercent)
            let firstCol:NSColor = (NSColor.green * Double(curPercent / 100))
            let secCol:NSColor = (NSColor(cgColor: NSColor.suake3DRed.cgColor)! * (1.0 - Double(curPercent / 100)))
            self.nodeReloadIndicator.fillColor = firstCol + secCol
            self.nodeReloadIndicator.strokeColor = firstCol + secCol
        })
        let actAct:SKAction = SKAction.group([secScaleAct, secColorAct])
        self.nodeReloadIndicator.run(SKAction.sequence([firstScaleAct, actAct]), completion: {
            self.nodeReloadIndicator.alpha = 0.0
        })
        self.game.showDbgMsg(dbgMsg: "startReloadBar() duration: " + duration.description, dbgLevel: .Verbose)
    }
    
    let reloadIndicatorPos:CGPoint = CGPoint(x: -30, y: 25)
    let reloadIndicatorSize:CGSize = CGSize(width: 60, height: 4)
    
    func createReloadShape(onHud:Bool = false)->SKShapeNode{
        nodeReloadIndicator.fillColor = SKColor.green
        nodeReloadIndicator.strokeColor = SKColor.green
        nodeReloadIndicator.isAntialiased = false
        let path = CGMutablePath()
        if(onHud){
            path.move(to: self.reloadIndicatorPos)
            path.addRect(CGRect(origin: self.reloadIndicatorPos, size: self.reloadIndicatorSize))
        }else{
            path.move(to: self.reloadIndicatorPos)
            path.addRect(CGRect(origin: self.reloadIndicatorPos, size: self.reloadIndicatorSize))
        }
        nodeReloadIndicator.path = path
        self.nodeContainer.addChild(self.nodeReloadIndicator)
        return nodeReloadIndicator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
