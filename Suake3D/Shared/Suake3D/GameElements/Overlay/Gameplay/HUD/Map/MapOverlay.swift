//
//  MapOverlay.swift
//  Suake3D
//
//  Created by Kim David Hauser on 18.03.21.
//

import Foundation
import SceneKit
import SpriteKit
import GameplayKit

class MapOverlay: SuakeGameClass {
    
    let hud:HUDOverlayScene
    
    var origY:CGFloat = 0
    var origX:CGFloat = 0
    var mapWidth:CGFloat = 0.0
    var mapHeight:CGFloat = 0.0
    var lineCount:Int = 21
    let lineWidthRect:CGFloat = 10.0
    let lineWidthGrid:CGFloat = 2.0
    var fieldWidth:CGFloat = 2.0
    var centerPoint:CGPoint!
    
    var map:SKShapeNode!
    var mapShapeNode:SKShapeNode!
    var mapBGShapeNode:SKShapeNode!
    var gridShapeNode:SKShapeNode!
    var mapPath:CGMutablePath!
    var gridPath:CGMutablePath!
    var alpha:CGFloat = 1.0
    
    var suakeOwnNode:SuakeSpriteNode!
    var suakeOppNode:SuakeSpriteNode!
    var goodyNode:SuakeSpriteNode!
    var droidNodes:[SuakeSpriteNodeMultiTextures] = [SuakeSpriteNodeMultiTextures]()
    var medKitNodes:[SuakeSpriteNode] = [SuakeSpriteNode]()
    
    var zoomScaleFactor:CGFloat = 0.35
    var zoomOn:Bool = true
    var originalPos:CGPoint!
    
    let iconMediKit:SKTexture = SKTexture(imageNamed: "art.scnassets/overlays/gameplay/map/First-aid-kit-NG_48x48.png")
    
    init(game: GameController, hud:HUDOverlayScene) {
        self.hud = hud
        super.init(game: game)
        self.initParams()
    }
    
    func initParams(){
        self.mapHeight = (self.game.scnView.window?.frame.size.height)! - (2 * 40)
        self.mapWidth = self.mapHeight
        self.centerPoint = CGPoint(x: (mapHeight / -2), y: (mapHeight / -2))
        _ = self.updateLineCount()
    }
    
    var mapDrawn:Bool = false
    func updateMap(byPassCheck:Bool = false){
        if(!self.mapDrawn || byPassCheck){
            self.mapDrawn = true
            if(self.map != nil && byPassCheck){
                self.map.removeFromParent()
            }
            self.hud.sceneNode.addChild(self.getMap())
        }
    }
    
    func getMap()->SKShapeNode{
//        if let map = self.map{
//            map.removeAllChildren()
//        }
        return self.drawMap()
    }
    
    func drawMap()->SKShapeNode{
        let addCnt:Int = self.updateLineCount()
        
        map = SKShapeNode()
        map.zPosition = 100
        map.run(SKAction.run {
//            self.portals.removeAll()
            
            self.mapShapeNode = SKShapeNode()
            self.mapShapeNode.strokeColor = SuakeColors.MapGridBorderColor
            self.gridShapeNode = SKShapeNode()
            self.gridShapeNode.strokeColor = SuakeColors.MapGridColor
            
            self.mapPath = CGMutablePath()
            self.gridPath = CGMutablePath()
            self.mapPath.addRect(CGRect(origin: self.centerPoint, size: CGSize(width: self.mapHeight, height: self.mapHeight)))

            self.mapShapeNode.path = self.mapPath
            self.mapShapeNode.lineWidth = self.lineWidthRect
            self.mapShapeNode.fillColor = NSColor.darkGray.withAlphaComponent(0.45)
            self.mapShapeNode.alpha = self.alpha
            self.mapShapeNode.name = "MapRectShape"

            self.mapBGShapeNode = SKShapeNode()
            self.mapBGShapeNode.strokeColor = SuakeColors.MapGridBorderColor
            self.mapBGShapeNode.fillColor = SuakeColors.MapGridBorderColor
            self.mapBGShapeNode.path = self.mapPath
            self.mapBGShapeNode.lineWidth = self.lineWidthRect
            self.mapBGShapeNode.alpha = 0.35
            self.mapBGShapeNode.name = "MapRectBGShape"

            self.map.addChild(self.mapBGShapeNode)
            self.map.addChild(self.mapShapeNode)
            self.map.addChild(self.gridShapeNode)
            
            for i in (0..<Int(self.lineCount + addCnt)){
                self.gridPath.move(to: CGPoint(x: self.centerPoint.x, y: self.centerPoint.y + (CGFloat(Double(i)) * self.fieldWidth)))
                self.gridPath.addLine(to: CGPoint(x: (self.mapHeight) / 2, y: self.centerPoint.y + (CGFloat(Double(i)) * self.fieldWidth)))
                self.gridPath.move(to: CGPoint(x: self.centerPoint.x + (CGFloat(Double(i)) * self.fieldWidth), y: self.centerPoint.y))
                self.gridPath.addLine(to: CGPoint(x: self.centerPoint.x + (CGFloat(Double(i)) * self.fieldWidth), y: (self.mapHeight) / 2 + self.lineWidthGrid))
            }

            self.gridShapeNode.path = self.gridPath
            self.gridShapeNode.lineWidth = self.lineWidthGrid
            self.gridShapeNode.alpha = self.alpha
            self.gridShapeNode.name = "MapGridShape"
            
            self.drawNodes()
            self.addNodes()
            
            self.map.name = "MapOverlay"
        })
        map.position = CGPoint(x: (self.game.scnView.window?.frame.width)! / 2, y: (self.game.scnView.window?.frame.height)! / 2)
        self.originalPos = self.map.position
        return map
    }
    
    @discardableResult
    func updateLineCount()->Int{
        self.lineCount = Int(self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize().height)
        let addCnt:Int = ((self.lineCount / 2) % 2 == 1 ? 1 : 1)
        self.fieldWidth = (self.mapHeight) / CGFloat(self.lineCount + addCnt)
        return addCnt
    }
}
